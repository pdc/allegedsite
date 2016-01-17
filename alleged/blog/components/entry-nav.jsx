
import React from 'react';
import ReactDOM from 'react-dom';


export class EntryStore {
    constructor(options) {
        this.data = options.data;
        this.yearDataApi = options.yearDataApi;

        this._queuedYears = {};
    }

    getYears() {
        let years = [];
        for (let y = this.data.minYear; y <= this.data.maxYear; ++y) {
            years.push(y);
        }
        return years;
    }

    checkYearDataReady(year) {
        return 'years' in this.data && year in this.data.years;
    }

    getYearData(year) {
        if (!this.checkYearDataReady(year)) {
            return false;
        }
        return this.data.years[year];
    }

    /**
    * Fetch data for this year if it hasn’t been already.
    * Call the callback when data is ready.
    */
    loadYearData(year, onYearDataReady) {
        if (year in this._queuedYears) {
            // Overwrite the callback!
            this._queuedYears[year] = onYearDataReady;
            return;
        }

        this._queuedYears[year] = onYearDataReady;
        $.getJSON(
            this.yearDataApi,
            {year},
            obj => {
                if (!('years' in this.data)) {
                    this.data.years = {};
                }
                this.data.years[year] = obj;
                if (this._queuedYears[year]) {
                    this._queuedYears[year](year, obj);
                }
            });
    }
}


class EntryNavEntry extends React.Component {
    render() {
        const ymd = this.props.year + '-' + this.props.month + '-' + this.props.day;
        const dmy = this.props.day + ' ' + this.props.monthLabel + ' ' + this.props.year;
        if (this.props.isActive) {
            return (<li className="entry-link entry-link-active">
                    <strong>
                        <q>{this.props.title}</q>
                        <time dateTime={ymd}>{dmy}</time>
                    </strong>
                </li>);
        } else {
            return (<li className="entry-link">
                    <a href={this.props.href}>
                        <q>{this.props.title}</q>
                        <time dateTime={ymd}>{dmy}</time>
                    </a>
                </li>);
        }
    }
}


class EntryNavMonth extends React.Component {
    handleClick(ev) {
        ev.preventDefault();
        this.props.onMonthActivate(this.props.month);
    }

    render() {
        if (!this.props.isActive) {
            return (<li className="entry-nav-month">
                <a href="#" onClick={this.handleClick.bind(this)}>{this.props.label}</a></li>);
        }

        const entryComponents = this.props.entries.map(
            e => (<EntryNavEntry key={e.day} title={e.title} isActive={e.isActive}
                    year={this.props.year} month={this.props.month} monthLabel={this.props.label} day={e.day}
                    href={e.href} />));
        return (<li className="entry-nav-month entry-nav-month-active">
                <b>{this.props.label}</b>
                <ul>
                    {entryComponents}
                </ul>
            </li>);
    }
}


const COLLAPSED = 0, LOADING = 1, EXPANDING = 2, EXPANDED = 3, COLLAPSING = 4;
const APPEARANCE_NAMES = ['collapsed', 'loading', 'expanding', 'expanded', 'collapsing'];
class EntryNavYear extends React.Component {
    constructor(props, context) {
        super(props, context);


        const isReady = this.props.entryStore.checkYearDataReady(this.props.year);
        let month = this.props.month;
        if (!month && isReady) {
            const yearData = this.props.entryStore.getYearData(this.props.year);
            if (yearData && yearData.months && yearData.months.length > 0) {
                month = yearData.months[0].month;
            }
        }
        this.state = {
            month,
            appearance: (!this.props.isActive ? COLLAPSED : isReady ? EXPANDED : LOADING),
        };
    }

    componentDidMount() {
        if (this.props.isActive) {
            this.loadYearData();
        }
    }

    componentWillReceiveProps(nextProps) {
        if (nextProps.isActive && !this.props.isActive) {
            const isReady = this.props.entryStore.checkYearDataReady(this.props.year);
            if (!isReady) {
                this.loadYearData();
            } else {
                this.startTransition(EXPANDING);
            }
        } else if (!nextProps.isActive && this.props.isActive) {
            this.startTransition(COLLAPSING);
        }
    }

    loadYearData() {
        const isReady = this.props.entryStore.checkYearDataReady(this.props.year);

        if (!isReady) {
            this.setState({appearance: LOADING});
            this.props.entryStore.loadYearData(this.props.year, (year, yearData) => {
                this.setState({month: yearData.months[0].month});
                this.startTransition(EXPANDING);
            });
        }
    }

    handleMonthActivate(month) {
        this.setState({
            month,
        });
    }

    startTransition(appearance) {
        // We transition between states so we can use CSS transitions on
        this.setState({appearance: appearance}, () => {
            // At this point we have set the root elt to the start state of the transition.
            // We want to add a CSS class after one tick to trigger the transition.
            window.setTimeout(() => {
                let elt = ReactDOM.findDOMNode(this);
                $(elt).addClass('entry-nav-year-' + APPEARANCE_NAMES[appearance] + '-active');
                elt.addEventListener('transitionend', this.handleTransitionEnd.bind(this), true);
                elt.addEventListener('webkitTransitionEnd', this.handleTransitionEnd.bind(this), true);
            }, 1);
        });
    }

    handleTransitionEnd(ev) {
        if (this.state.appearance === EXPANDING) {
            this.setState({appearance: EXPANDED});
        } else if (this.state.appearance === COLLAPSING) {
            this.setState({appearance: COLLAPSED});
        }

        let elt = ReactDOM.findDOMNode(this);
        elt.removeEventListener('transitionend', this.handleTransitionEnd);
        elt.removeEventListener('webkitTransitionEnd', this.handleTransitionEnd);
    }

    handleClick(ev) {
        ev.preventDefault();
        this.props.onYearActivate(this.props.year);
    }

    render() {
        const isCollapsed = this.state.appearance === COLLAPSED;
        if (this.state.appearance === COLLAPSED) {
            return (<li className="entry-nav-year entry-nav-year-collapsed">
                <a href="#" onClick={this.handleClick.bind(this)}>{this.props.year}</a>
            </li>);
        }

        const yearData = this.props.entryStore.getYearData(this.props.year);
        const monthComponents = yearData && yearData.months.map(
            m => (<EntryNavMonth key={m.month} isActive={m.month === this.state.month}
                        label={m.label} year={this.props.year} month={m.month}
                        entries={m.entries}
                        onMonthActivate={this.handleMonthActivate.bind(this)} />));
        const className = 'entry-nav-year-active entry-nav-year-' + APPEARANCE_NAMES[this.state.appearance];
        return (<li className={className}>
                <b>{this.props.year}</b>
                <ul>
                    {monthComponents}
                </ul>
            </li>);
    }
}


export class EntryNav extends React.Component {
    constructor(props, context) {
        super(props, context);

        const d = props.initialDate || new Date();
        this.state = {
            year: d.getFullYear(),
            month: 1 + d.getMonth(),
            loading: {},
        };
    }

    render() {
        const years = this.props.entryStore.getYears();
        const yearComponents = years.map(y => (
            <EntryNavYear key={y}
                    year={y} month={this.state.month} day={this.state.day}
                    isActive={y === this.state.year}
                    onYearActivate={this.handleYearActivate.bind(this)}
                    entryStore={this.props.entryStore} />));
        return (
            <div>
                <ul className="archive-year-list">
                    {yearComponents}
                </ul>
            </div>
        );
    }

    handleYearActivate(year) {
        // TODO Set date to that of first article in the year I guess
        this.setState({
            year,
            month: false,
        });
    }
}
