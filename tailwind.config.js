/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{js,jsx}'],
  theme: {
    extend: {
      colors: {
        ember: '#ffbf38',
        honey: '#f7f2ff',
        parchment: '#f7f2ff',
        bark: '#2c1738',
        root: '#12091d',
        moss: '#66f28b',
        pine: '#090711',
        night: '#05030a',
        purple: '#b517ff',
        pink: '#ff4fd8',
        cyan: '#43d9ff',
        muted: '#b9a9cb',
      },
      fontFamily: {
        display: ['"Trebuchet MS"', 'Verdana', 'sans-serif'],
        body: ['Inter', 'ui-sans-serif', 'system-ui', 'sans-serif'],
      },
      boxShadow: {
        glow: '0 0 42px rgba(181, 23, 255, 0.28), 0 0 70px rgba(67, 217, 255, 0.14)',
        insetPixel: 'inset 0 0 0 2px rgba(255, 255, 255, 0.11), inset 0 0 34px rgba(181, 23, 255, 0.16)',
      },
      animation: {
        twinkle: 'twinkle 4s ease-in-out infinite',
      },
      keyframes: {
        twinkle: {
          '0%, 100%': { opacity: '0.3', transform: 'translateY(0)' },
          '50%': { opacity: '0.95', transform: 'translateY(-8px)' },
        },
      },
    },
  },
  plugins: [],
};
