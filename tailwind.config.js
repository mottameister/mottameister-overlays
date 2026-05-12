/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{js,jsx}'],
  theme: {
    extend: {
      colors: {
        ember: '#f2a23a',
        honey: '#ffd98b',
        parchment: '#f6e6bf',
        bark: '#4b2f1d',
        root: '#2a1a10',
        moss: '#31422b',
        pine: '#16231a',
        night: '#120d09',
      },
      fontFamily: {
        display: ['"Trebuchet MS"', 'Verdana', 'sans-serif'],
        body: ['Inter', 'ui-sans-serif', 'system-ui', 'sans-serif'],
      },
      boxShadow: {
        glow: '0 0 42px rgba(242, 162, 58, 0.22)',
        insetPixel: 'inset 0 0 0 2px rgba(255, 217, 139, 0.22), inset 0 0 28px rgba(0, 0, 0, 0.28)',
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
