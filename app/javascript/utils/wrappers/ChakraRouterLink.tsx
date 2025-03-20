import * as React from "react";
import {
  Link as RouterLink,
  LinkProps as RouterLinkProps,
} from "react-router-dom";

// Create a component that forwards refs and has the proper types
const ChakraRouterLink = React.forwardRef<HTMLAnchorElement, RouterLinkProps>(
  (props, ref) => {
    return <RouterLink ref={ref} {...props} />;
  }
);

ChakraRouterLink.displayName = "ChakraRouterLink";

export default ChakraRouterLink;
