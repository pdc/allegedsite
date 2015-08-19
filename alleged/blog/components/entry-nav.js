'use strict';

var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }

var EntryStore = (function () {
    function EntryStore(options) {
        _classCallCheck(this, EntryStore);

        this.data = options.data;
        this.yearDataApi = options.yearDataApi;

        this._queuedYears = {};
    }

    _createClass(EntryStore, [{
        key: 'getYears',
        value: function getYears() {
            var years = [];
            for (var y = this.data.minYear; y <= this.data.maxYear; ++y) {
                years.push(y);
            }
            return years;
        }
    }, {
        key: 'checkYearDataReady',
        value: function checkYearDataReady(year) {
            return 'years' in this.data && year in this.data.years;
        }
    }, {
        key: 'getYearData',
        value: function getYearData(year) {
            if (!this.checkYearDataReady(year)) {
                return false;
            }
            return this.data.years[year];
        }

        /**
        * Fetch data for this year if it hasn’t been already.
        * Call the callback when data is ready.
        */
    }, {
        key: 'loadYearData',
        value: function loadYearData(year, onYearDataReady) {
            var _this = this;

            if (year in this._queuedYears) {
                // Overwrite the callback!
                this._queuedYears[year] = onYearDataReady;
                return;
            }

            this._queuedYears[year] = onYearDataReady;
            $.getJSON(this.yearDataApi, { year: year }, function (obj) {
                if (!('years' in _this.data)) {
                    _this.data.years = {};
                }
                _this.data.years[year] = obj;
                if (_this._queuedYears[year]) {
                    _this._queuedYears[year](year, obj);
                }
            });
        }
    }]);

    return EntryStore;
})();

var EntryNavEntry = React.createClass({
    displayName: 'EntryNavEntry',

    render: function render() {
        var ymd = this.props.year + '-' + this.props.month + '-' + this.props.day;
        var dmy = this.props.day + ' ' + this.props.monthLabel + ' ' + this.props.year;
        if (this.props.isActive) {
            return React.createElement(
                'li',
                { className: 'entry-link entry-link-active' },
                React.createElement(
                    'strong',
                    null,
                    React.createElement(
                        'q',
                        null,
                        this.props.title
                    ),
                    React.createElement(
                        'time',
                        { dateTime: ymd },
                        dmy
                    )
                )
            );
        } else {
            return React.createElement(
                'li',
                { className: 'entry-link' },
                React.createElement(
                    'a',
                    { href: this.props.href },
                    React.createElement(
                        'q',
                        null,
                        this.props.title
                    ),
                    React.createElement(
                        'time',
                        { dateTime: ymd },
                        dmy
                    )
                )
            );
        }
    }
});

var EntryNavMonth = React.createClass({
    displayName: 'EntryNavMonth',

    handleClick: function handleClick(ev) {
        ev.preventDefault();
        this.props.onMonthActivate(this.props.month);
    },

    render: function render() {
        var _this2 = this;

        if (!this.props.isActive) {
            return React.createElement(
                'li',
                { className: 'entry-nav-month' },
                React.createElement(
                    'a',
                    { href: '#', onClick: this.handleClick },
                    this.props.label
                )
            );
        }

        var entryComponents = this.props.entries.map(function (e) {
            return React.createElement(EntryNavEntry, { key: e.day, title: e.title, isActive: e.isActive,
                year: _this2.props.year, month: _this2.props.month, monthLabel: _this2.props.label, day: e.day,
                href: e.href });
        });
        return React.createElement(
            'li',
            { className: 'entry-nav-month entry-nav-month-active' },
            React.createElement(
                'b',
                null,
                this.props.label
            ),
            React.createElement(
                'ul',
                null,
                entryComponents
            )
        );
    }
});

var EntryNavYear = React.createClass({
    displayName: 'EntryNavYear',

    getInitialState: function getInitialState() {
        var isActive = this.props.isActive;
        var isReady = this.props.entryStore.checkYearDataReady(this.props.year);
        var isLoading = isActive && !isReady;
        var month = this.props.month;
        if (!month && isReady) {
            var yearData = this.props.entryStore.getYearData(this.props.year);
            if (yearData && yearData.months && yearData.months.length > 0) {
                month = yearData.months[0].month;
            }
        }
        return {
            month: month,
            isLoading: isLoading,
            isAppearing: false,
            isAppearingActive: false
        };
    },

    componentDidMount: function componentDidMount() {
        if (this.props.isActive) {
            this.loadYearData();
        }
    },

    componentWillReceiveProps: function componentWillReceiveProps(nextProps) {
        var _this3 = this;

        if (nextProps.isActive && !this.props.isActive) {
            this.loadYearData();

            // Trigger the animated appearance
            this.setState({ isAppearing: true });
            window.setTimeout(function () {
                _this3.setState({ isAppearingActive: true }, function () {
                    var elt = React.findDOMNode(_this3);
                    elt.addEventListener('transitionend', _this3.handleTransitionEnd, true);
                    elt.addEventListener('webkitTransitionEnd', _this3.handleTransitionEnd, true);
                });
            }, 1);
        }
    },

    loadYearData: function loadYearData() {
        var _this4 = this;

        var isReady = this.props.entryStore.checkYearDataReady(this.props.year);

        if (!isReady) {
            this.setState({ isLoading: true });
            this.props.entryStore.loadYearData(this.props.year, function (year, yearData) {
                _this4.setState({
                    isLoading: false,
                    month: yearData.months[0].month
                });
            });
        }
    },

    handleMonthActivate: function handleMonthActivate(month) {
        this.setState({
            month: month
        });
    },

    handleTransitionEnd: function handleTransitionEnd(ev) {
        this.setState({ isAppearing: false, isAppearingActive: false });

        var elt = React.findDOMNode(this);
        elt.removeEventListener('transitionend', this.handleTransitionEnd);
        elt.removeEventListener('webkitTransitionEnd', this.handleTransitionEnd);
    },

    handleClick: function handleClick(ev) {
        ev.preventDefault();
        this.props.onYearActivate(this.props.year);
    },

    render: function render() {
        var _this5 = this;

        if (!this.props.isActive) {
            return React.createElement(
                'li',
                { className: 'entry-nav-year' },
                React.createElement(
                    'a',
                    { href: '#', onClick: this.handleClick },
                    this.props.year
                )
            );
        }

        var yearData = this.props.entryStore.getYearData(this.props.year);
        var monthComponents = yearData && yearData.months.map(function (m) {
            return React.createElement(EntryNavMonth, { key: m.month, isActive: m.month === _this5.state.month,
                label: m.label, year: _this5.props.year, month: m.month,
                entries: m.entries,
                onMonthActivate: _this5.handleMonthActivate });
        });
        var className = 'entry-nav-year-active';
        if (this.state.isLoading) {
            className += ' entry-nav-year-loading';
        }
        if (this.state.isAppearing) {
            className += ' entry-nav-year-appearing';
        }
        if (this.state.isAppearingActive) {
            className += ' entry-nav-year-appearing-active';
        }
        return React.createElement(
            'li',
            { className: className },
            React.createElement(
                'b',
                null,
                this.props.year
            ),
            React.createElement(
                'ul',
                { ref: 'transitioning' },
                monthComponents
            )
        );
    }
});

var EntryNav = React.createClass({
    displayName: 'EntryNav',

    getInitialState: function getInitialState() {
        var d = this.props.initialDate || new Date();
        return {
            year: d.getFullYear(),
            month: 1 + d.getMonth(),
            loading: {}
        };
    },

    render: function render() {
        var _this6 = this;

        var years = this.props.entryStore.getYears();
        var yearComponents = years.map(function (y) {
            return React.createElement(EntryNavYear, { key: y,
                year: y, month: _this6.state.month, day: _this6.state.day,
                isActive: y === _this6.state.year,
                onYearActivate: _this6.handleYearActivate,
                entryStore: _this6.props.entryStore });
        });
        return React.createElement(
            'div',
            null,
            React.createElement(
                'ul',
                { className: 'archive-year-list' },
                yearComponents
            )
        );
    },

    handleYearActivate: function handleYearActivate(year) {
        // TODO Set date to that of first article in the year I guess
        this.setState({
            year: year,
            month: false
        });
    }
});

function activateEntryNav(entryStore, initialDate, elementID) {
    React.render(React.createElement(EntryNav, { entryStore: entryStore, initialDate: initialDate }), document.getElementById(elementID));
}

