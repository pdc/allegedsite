
class EntryStore {
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

var EntryNavEntry = React.createClass({
    render: function () {
        const ymd = this.props.year + '-' + this.props.month + '-' + this.props.day;
        const dmy = this.props.day + ' ' + this.props.monthLabel + ' ' + this.props.year;
        if (this.props.isActive) {
            return (<li className="archive-link article-link-active">
                    <strong>
                        <q>{this.props.title}</q>
                        <time dateTime={ymd}>{dmy}</time>
                    </strong>
                </li>);
        } else {
            return (<li className="archive-link">
                    <a href={this.props.href}>
                        <q>{this.props.title}</q>
                        <time dateTime={ymd}>{dmy}</time>
                    </a>
                </li>);
        }
    }
});


var EntryNavMonth = React.createClass({
    handleClick: function (ev) {
        ev.preventDefault();
        this.props.onMonthActivate(this.props.month);
    },

    render: function () {
        if (!this.props.isActive) {
            return (<li className="entry-nav-month">
                <a href="#" onClick={this.handleClick}>{this.props.label}</a></li>);
        }

        const entryComponents = this.props.entries.map(
            e => (<EntryNavEntry key={e.day} title={e.title} isActive={e.isActive}
                    year={this.props.year} month={this.props.month} monthLabel={this.props.label} day={e.day}
                    href={e.href} />));
        return (<li className="entry-nav-month">
                <b>{this.props.label}</b>
                <ul>
                    {entryComponents}
                </ul>
            </li>);
    }
});


var EntryNavYear = React.createClass({
    getInitialState: function () {
        const isActive = this.props.isActive;
        const isReady = this.props.entryStore.checkYearDataReady(this.props.year);
        const isLoading = isActive && !isReady;
        let month = this.props.month;
        if (!month && isReady) {
            const yearData = this.props.entryStore.getYearData(this.props.year);
            if (yearData && yearData.months && yearData.months.length > 0) {
                month = yearData.months[0].month;
            }
        }
        return {
            month,
            isLoading,
            isAppearing: false,
            isAppearingActive: false,
        };
    },

    componentDidMount: function () {
        if (this.props.isActive) {
            this.loadYearData();
        }
    },

    componentWillReceiveProps: function (nextProps) {
        if (nextProps.isActive && !this.props.isActive) {
            this.loadYearData();

            // Trigger the animated appearance
            this.setState({isAppearing: true});
            window.setTimeout(() => {
                this.setState({isAppearingActive: true}, () => {
                    let elt = React.findDOMNode(this);
                    elt.addEventListener('transitionend', this.handleTransitionEnd, true);
                    elt.addEventListener('webkitTransitionEnd', this.handleTransitionEnd, true);
                });
            }, 1);
        }
    },

    loadYearData: function () {
        const isReady = this.props.entryStore.checkYearDataReady(this.props.year);

        if (!isReady) {
            this.setState({isLoading: true});
            this.props.entryStore.loadYearData(this.props.year, (year, yearData) => {
                this.setState({
                    isLoading: false,
                    month: yearData.months[0].month,
                });
            });
        }
    },

    handleMonthActivate: function (month) {
        this.setState({
            month,
        });
    },

    handleTransitionEnd: function (ev) {
        this.setState({isAppearing: false, isAppearingActive: false});

        let elt = React.findDOMNode(this);
        elt.removeEventListener('transitionend', this.handleTransitionEnd);
        elt.removeEventListener('webkitTransitionEnd', this.handleTransitionEnd);
    },

    handleClick: function (ev) {
        ev.preventDefault();
        this.props.onYearActivate(this.props.year);
    },

    render: function () {
        if (!this.props.isActive) {
            return (<li className="entry-nav-year">
                <a href="#" onClick={this.handleClick}>{this.props.year}</a>
            </li>);
        }

        const yearData = this.props.entryStore.getYearData(this.props.year);
        const monthComponents = yearData && yearData.months.map(
            m => (<EntryNavMonth key={m.month} isActive={m.month === this.state.month}
                        label={m.label} year={this.props.year} month={m.month}
                        entries={m.entries}
                        onMonthActivate={this.handleMonthActivate} />));
        let className = 'entry-nav-year-active';
        if (this.state.isLoading) {
            className += ' entry-nav-year-loading';
        }
        if (this.state.isAppearing) {
            className += ' entry-nav-year-appearing';
        }
        if (this.state.isAppearingActive) {
            className += ' entry-nav-year-appearing-active';
        }
        return (<li className={className}>
                <b>{this.props.year}</b>
                <ul ref="transitioning">
                    {monthComponents}
                </ul>
            </li>);
    },
});


var EntryNav = React.createClass({
    getInitialState: function () {
        const d = this.props.initialDate || new Date();
        return {
            year: d.getFullYear(),
            month: 1 + d.getMonth(),
            loading: {},
        };
    },

    render: function () {
        const years = this.props.entryStore.getYears();
        const yearComponents = years.map(y => (<EntryNavYear key={y}
                    year={y} month={this.state.month} day={this.state.day}
                    isActive={y === this.state.year}
                    onYearActivate={this.handleYearActivate}
                    entryStore={this.props.entryStore} />));
        return (
            <div>
                <ul className="archive-year-list">
                    {yearComponents}
                </ul>
            </div>
        );
    },

    handleYearActivate: function (year) {
        // TODO Set date to that of first article in the year I guess
        this.setState({
            year,
            month: false,
        });
    }
});

function activateEntryNav(entryStore, initialDate, elementID) {
    React.render(<EntryNav entryStore={entryStore} initialDate={initialDate} />,
        document.getElementById(elementID));
}
