import React from "react";
import { render } from "react-dom";

import { MDXProvider } from "@mdx-js/react";

import {
  themes: { defaultTheme},
  Deck,
  FlexBox,
  Slide,
  Box,
  Progress,
  FullScreen,
  Notes,
  mdxComponentMap
} from "spectacle";

// SPECTACLE_CLI_MDX_START
import slides, { notes } from "./slides.mdx";
// SPECTACLE_CLI_MDX_END

// SPECTACLE_CLI_THEME_START
const colors = {
  primary: "white",
  secondary: "#22211f", // almost black w/ blueish tint
  tertiary: "#1F2022", // complement of secondary
  quaternary: "#737373" // gray
};

const marginBottom = "0.5em";

const lineHeight = "1.2em !important";

const theme = defaultTheme(
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
        fontSize: "3.5vmin"
      }
    }
  }
);
// SPECTACLE_CLI_THEME_END

// SPECTACLE_CLI_TEMPLATE_START
const template = () => (
  <FlexBox
    justifyContent="space-between"
    position="absolute"
    bottom={0}
    width={1}
  >
    <Box padding="0 1em">
      <FullScreen />
    </Box>
    <Box padding="1em">
      <Progress />
    </Box>
  </FlexBox>
);
// SPECTACLE_CLI_TEMPLATE_END

const Presentation = () => (
  <MDXProvider components={mdxComponentMap}>
    <Deck loop theme={theme} template={template}>
      {slides
        .map((MDXSlide, i) => [MDXSlide, notes[i]])
        .map(([MDXSlide, MDXNote], i) => (
          <Slide key={`slide-${i}`} slideNum={i}>
            <MDXSlide />
            <Notes>
              <MDXNote />
            </Notes>
          </Slide>
        ))}
    </Deck>
  </MDXProvider>
);

render(<Presentation />, document.getElementById("root"));
