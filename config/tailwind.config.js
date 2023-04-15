const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', 'Lora', 'Raleway', 'Limelight', ...defaultTheme.fontFamily.sans],
      },
      colors: {
        light: "#d5e9f5",
        med: "#92c4d1",
        dark: "#414347",
        navy: "#082736",
        red: "#ae1f23",
        cyan: "#33d6ea",
        pink: "#ee7567",
        green: "#008800",
        purple: "#7b185d",
        blue: "#007dae",
        "twitter-color": "#006da3",
        "github-color": "#4b4b4b",
      }
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
  ]
}
