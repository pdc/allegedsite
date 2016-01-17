import React from 'react';
import {render} from 'react-dom';

import {EntryStore} from './entry-store';
import {EntryNav} from './entry-nav';


window.entryPage = function (options) {
    var entryStore = new EntryStore(options.store);
    render(<EntryNav entryStore={entryStore} initialDate={options.date} />, options.element);
}
