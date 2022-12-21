/*
*
* How information about entries is exposed to the rest of the system.
*
*/


/* global Promise */
/* global fetch */


export class EntryStore {
    /**
    * Create a store.
    *
    * options --
    *  data -- information about the current year’s entries
    *  yearDataApi -- URL for getting additonal years’ data.
    */
    constructor(options) {
        this.data = options.data;
        this.yearDataApi = options.yearDataApi;

        // We return the same promise each time a year is requested.
        this._promisesByYear = {};
    }

    getYears() {
        return Object.keys(this.data.years).sort();
    }

    checkYearDataReady(year) {
        return this.data.years && this.data.years[year];
    }

    getYearData(year) {
        if (!this.checkYearDataReady(year)) {
            return false;
        }
        return this.data.years[year];
    }

    /**
    * Fetch data for this year if it hasn’t been already.
    *
    * Returns a promise.
    */
    loadYearData(year, onYearDataReady) {
        if (!(year in this._promisesByYear)) {
            this._promisesByYear[year] = fetch(this.yearDataApi + '?year=' + year)
            .then(response => {
                if (response.status >= 200 && response.status < 400) {
                    return response.json();
                } else {
                    var error = new Error(response.statusText)
                    error.response = response
                    throw error
                }
            })
            .then(obj => {
                if (!('years' in this.data)) {
                    this.data.years = {};
                }
                this.data.years[year] = obj;
                return {year: year, yearData: obj};
            });
        }

        return this._promisesByYear[year];
    }
}
