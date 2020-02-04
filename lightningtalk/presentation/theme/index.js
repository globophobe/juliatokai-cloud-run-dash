import createTheme from "../../createTheme";

const colors = {
  primary: "white",
  secondary: "#22211f", // almost black w/ blueish tint
  tertiary: "#1F2022", // complement of secondary
  quaternary: "#737373" // gray
};

const marginBottom = "0.5em";
const lineHeight = "1.2em !important";

const theme = createTheme(
  colors,
  {
    primary: "Montserrat",
    secondary: "Helvetica"
  },
  {
    progress: {
      pacmanTop: {
        background: colors.quaternary
      },
      pacmanBottom: {
        background: colors.quaternary
      },
      point: {
        borderColor: colors.quaternary
      }
    },
    components: {
      heading: {
        h1: {
          fontSize: "9vmin",
          lineHeight,
          marginBottom
        },
        h2: {
          fontSize: "8.5vmin",
          lineHeight,
          marginBottom
        },
        h3: {
          fontSize: "8vmin",
          lineHeight,
          marginBottom
        },
        h4: {
          fontSize: "7.5vmin",
          lineHeight,
          marginBottom
        },
        h5: {
          fontSize: "7vmin",
          lineHeight,
          marginBottom
        },
        h6: {
          fontSize: "6.5vmin",
          lineHeight,
          marginBottom
        }
      },
      link: {
        color: "#111e6c"
      },
      codePane: {
        fontSize: "3vmin"
      }
    }
  }
);

export default theme;
