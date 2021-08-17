const { VueLoaderPlugin } = require('vue-loader');

module.exports = {
  plugins: [
    new VueLoaderPlugin(),
  ],

  resolve: {
    alias: {
      vue: 'vue/dist/vue.js',
    }
  },

  module: {
    rules: [
      {
        test:   /\.vue$/,
        loader: 'vue-loader',
      },
    ],
  },
}
