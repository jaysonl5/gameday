import React from "react";
import { Card, Text } from "@chakra-ui/react";

export const DashboardCard: React.FC = (title, body, footer) => {
  return (
    <Card.Root width="1/4">
      <Card.Header>
        <Card.Title>{title}</Card.Title>
      </Card.Header>
      <Card.Body>
        <Text>{body}</Text>
      </Card.Body>
      <Card.Footer>
        <Text textStyle="sm">{footer}</Text>
      </Card.Footer>
    </Card.Root>
  );
};
