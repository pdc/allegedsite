'use strict';

Object.defineProperty(exports, '__esModule', {
    value: true
});

var _get = function get(_x, _x2, _x3) { var _again = true; _function: while (_again) { var object = _x, property = _x2, receiver = _x3; desc = parent = getter = undefined; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x = parent; _x2 = property; _x3 = receiver; _again = true; continue _function; } } else if ('value' in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };

var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }

function _inherits(subClass, superClass) { if (typeof superClass !== 'function' && superClass !== null) { throw new TypeError('Super expression must either be null or a function, not ' + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }

var _react = require('react');

var _react2 = _interopRequireDefault(_react);

var _reactDom = require('react-dom');

var _reactDom2 = _interopRequireDefault(_reactDom);

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

exports.EntryStore = EntryStore;

var EntryNavEntry = (function (_React$Component) {
    _inherits(EntryNavEntry, _React$Component);

    function EntryNavEntry() {
        _classCallCheck(this, EntryNavEntry);

        _get(Object.getPrototypeOf(EntryNavEntry.prototype), 'constructor', this).apply(this, arguments);
    }

    _createClass(EntryNavEntry, [{
        key: 'render',
        value: function render() {
            var ymd = this.props.year + '-' + this.props.month + '-' + this.props.day;
            var dmy = this.props.day + ' ' + this.props.monthLabel + ' ' + this.props.year;
            if (this.props.isActive) {
                return _react2['default'].createElement(
                    'li',
                    { className: 'entry-link entry-link-active' },
                    _react2['default'].createElement(
                        'strong',
                        null,
                        _react2['default'].createElement(
                            'q',
                            null,
                            this.props.title
                        ),
                        _react2['default'].createElement(
                            'time',
                            { dateTime: ymd },
                            dmy
                        )
                    )
                );
            } else {
                return _react2['default'].createElement(
                    'li',
                    { className: 'entry-link' },
                    _react2['default'].createElement(
                        'a',
                        { href: this.props.href },
                        _react2['default'].createElement(
                            'q',
                            null,
                            this.props.title
                        ),
                        _react2['default'].createElement(
                            'time',
                            { dateTime: ymd },
                            dmy
                        )
                    )
                );
            }
        }
    }]);

    return EntryNavEntry;
})(_react2['default'].Component);

var EntryNavMonth = (function (_React$Component2) {
    _inherits(EntryNavMonth, _React$Component2);

    function EntryNavMonth() {
        _classCallCheck(this, EntryNavMonth);

        _get(Object.getPrototypeOf(EntryNavMonth.prototype), 'constructor', this).apply(this, arguments);
    }

    _createClass(EntryNavMonth, [{
        key: 'handleClick',
        value: function handleClick(ev) {
            ev.preventDefault();
            this.props.onMonthActivate(this.props.month);
        }
    }, {
        key: 'render',
        value: function render() {
            var _this2 = this;

            if (!this.props.isActive) {
                return _react2['default'].createElement(
                    'li',
                    { className: 'entry-nav-month' },
                    _react2['default'].createElement(
                        'a',
                        { href: '#', onClick: this.handleClick.bind(this) },
                        this.props.label
                    )
                );
            }

            var entryComponents = this.props.entries.map(function (e) {
                return _react2['default'].createElement(EntryNavEntry, { key: e.day, title: e.title, isActive: e.isActive,
                    year: _this2.props.year, month: _this2.props.month, monthLabel: _this2.props.label, day: e.day,
                    href: e.href });
            });
            return _react2['default'].createElement(
                'li',
                { className: 'entry-nav-month entry-nav-month-active' },
                _react2['default'].createElement(
                    'b',
                    null,
                    this.props.label
                ),
                _react2['default'].createElement(
                    'ul',
                    null,
                    entryComponents
                )
            );
        }
    }]);

    return EntryNavMonth;
})(_react2['default'].Component);

var COLLAPSED = 0,
    LOADING = 1,
    EXPANDING = 2,
    EXPANDED = 3,
    COLLAPSING = 4;
var APPEARANCE_NAMES = ['collapsed', 'loading', 'expanding', 'expanded', 'collapsing'];

var EntryNavYear = (function (_React$Component3) {
    _inherits(EntryNavYear, _React$Component3);

    function EntryNavYear(props, context) {
        _classCallCheck(this, EntryNavYear);

        _get(Object.getPrototypeOf(EntryNavYear.prototype), 'constructor', this).call(this, props, context);

        var isReady = this.props.entryStore.checkYearDataReady(this.props.year);
        var month = this.props.month;
        if (!month && isReady) {
            var yearData = this.props.entryStore.getYearData(this.props.year);
            if (yearData && yearData.months && yearData.months.length > 0) {
                month = yearData.months[0].month;
            }
        }
        this.state = {
            month: month,
            appearance: !this.props.isActive ? COLLAPSED : isReady ? EXPANDED : LOADING
        };
    }

    _createClass(EntryNavYear, [{
        key: 'componentDidMount',
        value: function componentDidMount() {
            if (this.props.isActive) {
                this.loadYearData();
            }
        }
    }, {
        key: 'componentWillReceiveProps',
        value: function componentWillReceiveProps(nextProps) {
            if (nextProps.isActive && !this.props.isActive) {
                var isReady = this.props.entryStore.checkYearDataReady(this.props.year);
                if (!isReady) {
                    this.loadYearData();
                } else {
                    this.startTransition(EXPANDING);
                }
            } else if (!nextProps.isActive && this.props.isActive) {
                this.startTransition(COLLAPSING);
            }
        }
    }, {
        key: 'loadYearData',
        value: function loadYearData() {
            var _this3 = this;

            var isReady = this.props.entryStore.checkYearDataReady(this.props.year);

            if (!isReady) {
                this.setState({ appearance: LOADING });
                this.props.entryStore.loadYearData(this.props.year, function (year, yearData) {
                    _this3.setState({ month: yearData.months[0].month });
                    _this3.startTransition(EXPANDING);
                });
            }
        }
    }, {
        key: 'handleMonthActivate',
        value: function handleMonthActivate(month) {
            this.setState({
                month: month
            });
        }
    }, {
        key: 'startTransition',
        value: function startTransition(appearance) {
            var _this4 = this;

            // We transition between states so we can use CSS transitions on
            this.setState({ appearance: appearance }, function () {
                // At this point we have set the root elt to the start state of the transition.
                // We want to add a CSS class after one tick to trigger the transition.
                window.setTimeout(function () {
                    var elt = _reactDom2['default'].findDOMNode(_this4);
                    $(elt).addClass('entry-nav-year-' + APPEARANCE_NAMES[appearance] + '-active');
                    elt.addEventListener('transitionend', _this4.handleTransitionEnd.bind(_this4), true);
                    elt.addEventListener('webkitTransitionEnd', _this4.handleTransitionEnd.bind(_this4), true);
                }, 1);
            });
        }
    }, {
        key: 'handleTransitionEnd',
        value: function handleTransitionEnd(ev) {
            if (this.state.appearance === EXPANDING) {
                this.setState({ appearance: EXPANDED });
            } else if (this.state.appearance === COLLAPSING) {
                this.setState({ appearance: COLLAPSED });
            }

            var elt = _reactDom2['default'].findDOMNode(this);
            elt.removeEventListener('transitionend', this.handleTransitionEnd);
            elt.removeEventListener('webkitTransitionEnd', this.handleTransitionEnd);
        }
    }, {
        key: 'handleClick',
        value: function handleClick(ev) {
            ev.preventDefault();
            this.props.onYearActivate(this.props.year);
        }
    }, {
        key: 'render',
        value: function render() {
            var _this5 = this;

            var isCollapsed = this.state.appearance === COLLAPSED;
            if (this.state.appearance === COLLAPSED) {
                return _react2['default'].createElement(
                    'li',
                    { className: 'entry-nav-year entry-nav-year-collapsed' },
                    _react2['default'].createElement(
                        'a',
                        { href: '#', onClick: this.handleClick.bind(this) },
                        this.props.year
                    )
                );
            }

            var yearData = this.props.entryStore.getYearData(this.props.year);
            var monthComponents = yearData && yearData.months.map(function (m) {
                return _react2['default'].createElement(EntryNavMonth, { key: m.month, isActive: m.month === _this5.state.month,
                    label: m.label, year: _this5.props.year, month: m.month,
                    entries: m.entries,
                    onMonthActivate: _this5.handleMonthActivate.bind(_this5) });
            });
            var className = 'entry-nav-year-active entry-nav-year-' + APPEARANCE_NAMES[this.state.appearance];
            return _react2['default'].createElement(
                'li',
                { className: className },
                _react2['default'].createElement(
                    'b',
                    null,
                    this.props.year
                ),
                _react2['default'].createElement(
                    'ul',
                    null,
                    monthComponents
                )
            );
        }
    }]);

    return EntryNavYear;
})(_react2['default'].Component);

var EntryNav = (function (_React$Component4) {
    _inherits(EntryNav, _React$Component4);

    function EntryNav(props, context) {
        _classCallCheck(this, EntryNav);

        _get(Object.getPrototypeOf(EntryNav.prototype), 'constructor', this).call(this, props, context);

        var d = props.initialDate || new Date();
        this.state = {
            year: d.getFullYear(),
            month: 1 + d.getMonth(),
            loading: {}
        };
    }

    _createClass(EntryNav, [{
        key: 'render',
        value: function render() {
            var _this6 = this;

            var years = this.props.entryStore.getYears();
            var yearComponents = years.map(function (y) {
                return _react2['default'].createElement(EntryNavYear, { key: y,
                    year: y, month: _this6.state.month, day: _this6.state.day,
                    isActive: y === _this6.state.year,
                    onYearActivate: _this6.handleYearActivate.bind(_this6),
                    entryStore: _this6.props.entryStore });
            });
            return _react2['default'].createElement(
                'div',
                null,
                _react2['default'].createElement(
                    'ul',
                    { className: 'archive-year-list' },
                    yearComponents
                )
            );
        }
    }, {
        key: 'handleYearActivate',
        value: function handleYearActivate(year) {
            // TODO Set date to that of first article in the year I guess
            this.setState({
                year: year,
                month: false
            });
        }
    }]);

    return EntryNav;
})(_react2['default'].Component);

exports.EntryNav = EntryNav;

