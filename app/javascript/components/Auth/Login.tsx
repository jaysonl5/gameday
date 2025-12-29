import React, { useState } from "react";
import {
  Container,
  Paper,
  TextInput,
  PasswordInput,
  Button,
  Title,
  Text,
  Box,
  Center,
  Stack,
  Anchor,
  Divider,
  Alert
} from "@mantine/core";
import { FaGoogle } from "react-icons/fa";
import { MdWarning } from "react-icons/md";

interface LoginProps {
  csrfToken: string;
  error?: string;
  googleOAuthPath?: string;
}

export const Login: React.FC<LoginProps> = ({ csrfToken, error, googleOAuthPath }) => {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");

  return (
    <Box
      style={{
        minHeight: "100vh",
        background: "linear-gradient(135deg, #667eea 0%, #764ba2 100%)",
        display: "flex",
        alignItems: "center",
        justifyContent: "center",
        padding: "20px"
      }}
    >
      <Container size={420}>
        <Center mb="xl">
          <img
            src="/assets/images/logo.svg"
            alt="GameDay Logo"
            style={{ width: "200px", maxWidth: "100%" }}
          />
        </Center>

        <Paper shadow="xl" p="xl" radius="md" withBorder>
          <Stack gap="md">
            <Title order={2} ta="center" fw={700}>
              Welcome Back
            </Title>
            <Text c="dimmed" size="sm" ta="center">
              Sign in to access your dashboard
            </Text>

            {error && (
              <Alert icon={<MdWarning />} title="Error" color="red" variant="light">
                {error}
              </Alert>
            )}

            {googleOAuthPath && (
              <>
                <Button
                  component="a"
                  href={googleOAuthPath}
                  leftSection={<FaGoogle />}
                  variant="default"
                  size="lg"
                  fullWidth
                >
                  Sign in with Google
                </Button>

                <Divider label="or continue with email" labelPosition="center" />
              </>
            )}

            <form method="post" action="/users/sign_in">
              <input type="hidden" name="authenticity_token" value={csrfToken} />

              <Stack gap="md">
                <TextInput
                  label="Email"
                  placeholder="your@email.com"
                  name="user[email]"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  required
                  size="md"
                />

                <PasswordInput
                  label="Password"
                  placeholder="Your password"
                  name="user[password]"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  required
                  size="md"
                />

                <Button type="submit" size="lg" fullWidth>
                  Sign In
                </Button>
              </Stack>
            </form>

            <Text size="sm" ta="center" c="dimmed">
              Don't have an account?{" "}
              <Anchor href="/users/sign_up" size="sm">
                Sign up
              </Anchor>
            </Text>

            <Text size="xs" ta="center" c="dimmed">
              <Anchor href="/users/password/new" size="xs">
                Forgot password?
              </Anchor>
            </Text>
          </Stack>
        </Paper>

        <Text size="xs" c="white" ta="center" mt="xl">
          © 2025 GameDay Men's Health. All rights reserved.
        </Text>
      </Container>
    </Box>
  );
};
