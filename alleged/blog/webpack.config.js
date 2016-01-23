var webpack = require("webpack");

module.exports = {
    entry: './components/entry-page',
    output: {
        filename: 'entry.js',
        path: './static/js',
    },
    module: {
        loaders: [
            {
                test: /\.jsx?$/,
                loader: 'babel-loader',
                exclude: /node_modules/,
                query: {
                    presets: ['es2015', 'react'],
                }
            }
        ],
    },
    plugins: [
        new webpack.ProvidePlugin({
            'fetch': 'imports?this=>global!exports?global.fetch!whatwg-fetch'
        }),
        new webpack.optimize.OccurenceOrderPlugin(),
        new webpack.optimize.DedupePlugin(),
        new webpack.optimize.UglifyJsPlugin({}),
    ],
    resolve: {
        extensions: ['', '.webpack.js', '.web.js', '.js', '.jsx'],
    }
}
