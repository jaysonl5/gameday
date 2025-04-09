import { Container, Grid, Title } from "@mantine/core";
import React from "react";

export const Payments = () => {
  return (
    <Container size="xl">
      <Grid mb="lg">
        <Grid.Col>
          <Title order={1}>Payments</Title>
        </Grid.Col>
      </Grid>
      <p>
        <i>Coming soon...</i>
      </p>
    </Container>
  );
};
