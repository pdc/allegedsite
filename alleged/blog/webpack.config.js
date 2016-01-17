var webpack = require("webpack");

module.exports = {
    entry: './components/entry-page.jsx',
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
        new webpack.optimize.UglifyJsPlugin(),
        new webpack.optimize.OccurenceOrderPlugin(),
    ],
    resolve: {
        extensions: ['', '.webpack.js', '.web.js', '.js', '.jsx'],
    }
}
