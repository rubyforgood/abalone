module.exports = {
  theme: {
    boxShadow: {
      default: "0 2px 3px rgb(10 10 10 / 10%), 0 0 0 1px rgb(10 10 10 / 10%)",
      sm: "0 4px 10px rgba(60,106,139,0.15)",
      none: "none",
    },
    container: {
      center: true,
    },
    prefix: "tw-",
    fontSize: {
      title1: "2.5rem",
      title2: "2.25rem",
      title3: "1.875rem",
      title4: "1.25rem",
      body: "1rem",
      caption: "0.875rem",
    },
    extend: {
      colors: {
        "primary-dark": "#6767ca",
        background: "#f3f7fa",
        primary: "#9d9dd3",
        secondary: "#eb5757",
        dark: "#333333",
        light: "#ffffff",
        warning: "#f2994a",
        success: "#27ae60",
        "dark-light": "#eee",
        "caption-light": "#757586",
        "caption-dark": "#ACACC1",
      },
      inset: {
        "full": "100%",
      },
      spacing: {
        "full": "100%",
        "0.5": "0.125rem",
        "7": "1.75rem",
        "44": "11rem",
        "52": "13rem",
        "60": "15rem",
        "72": "18rem",
      },
    },
    screens: {
      'smico': '427px',
      'sm': '640px',
      'md': '768px',
      'lg': '1024px',
      'xl': '1280px',
      '2xl': '1536px',
    }
  },
  variants: {},
  plugins: [],
};
