
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
