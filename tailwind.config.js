/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./index.html",
    "./src/**/*.{js,jsx,ts,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        // Custom card colors
        'card-rot': '#ff3838',
        'card-gruen': '#2ed573',
        'card-blau': '#1e90ff',
        'card-lila': '#9b59b6',
        'card-wild': '#2f3542',
      },
      fontFamily: {
        'marker': ['Caveat', 'cursive'],
        'outfit': ['Outfit', 'sans-serif'],
      },
    },
  },
  plugins: [],
}
