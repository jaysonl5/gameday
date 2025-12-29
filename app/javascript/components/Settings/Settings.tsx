import React, { useState, useEffect } from "react";
import {
  Container,
  Paper,
  Title,
  Tabs,
  Stack,
  Button,
  Table,
  Select,
  PasswordInput,
  Text,
  Group,
  Badge,
  Alert
} from "@mantine/core";
import { FlaggedTitle } from "../Shared/FlaggedTitle";
import { MdSettings, MdSave } from "react-icons/md";
import { FaUserShield } from "react-icons/fa";
import axios from "axios";

interface User {
  id: number;
  email: string;
  name: string;
  role: string;
  approved: boolean;
}

const ROLES = [
  { value: "read_only", label: "Read Only - No write access" },
  { value: "limited", label: "Limited - Can't see payments or manage users" },
  { value: "full", label: "Full - Can see all pages" },
  { value: "admin", label: "Admin - Can see all and manage users" }
];

export const Settings: React.FC = () => {
  const [users, setUsers] = useState<User[]>([]);
  const [loading, setLoading] = useState(true);
  const [currentPassword, setCurrentPassword] = useState("");
  const [newPassword, setNewPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [passwordMessage, setPasswordMessage] = useState<{ type: 'success' | 'error', text: string } | null>(null);

  useEffect(() => {
    fetchUsers();
  }, []);

  const fetchUsers = async () => {
    try {
      const response = await axios.get('/api/v1/users');
      setUsers(response.data);
    } catch (error) {
      console.error('Failed to fetch users:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleRoleChange = async (userId: number, newRole: string) => {
    try {
      await axios.patch(`/api/v1/users/${userId}/role`, { role: newRole });
      setUsers(users.map(u => u.id === userId ? { ...u, role: newRole } : u));
    } catch (error) {
      console.error('Failed to update role:', error);
    }
  };

  const handlePasswordChange = async (e: React.FormEvent) => {
    e.preventDefault();
    setPasswordMessage(null);

    if (newPassword !== confirmPassword) {
      setPasswordMessage({ type: 'error', text: 'Passwords do not match' });
      return;
    }

    if (newPassword.length < 6) {
      setPasswordMessage({ type: 'error', text: 'Password must be at least 6 characters' });
      return;
    }

    try {
      await axios.patch('/users', {
        user: {
          current_password: currentPassword,
          password: newPassword,
          password_confirmation: confirmPassword
        }
      });
      setPasswordMessage({ type: 'success', text: 'Password updated successfully' });
      setCurrentPassword('');
      setNewPassword('');
      setConfirmPassword('');
    } catch (error: any) {
      setPasswordMessage({
        type: 'error',
        text: error.response?.data?.error || 'Failed to update password'
      });
    }
  };

  const getRoleBadgeColor = (role: string) => {
    switch (role) {
      case 'admin': return 'red';
      case 'full': return 'blue';
      case 'limited': return 'yellow';
      case 'read_only': return 'gray';
      default: return 'gray';
    }
  };

  return (
    <Container size="xl">
      <Paper shadow="sm" p="lg" radius="md">
        <FlaggedTitle titleText="Settings" leftIcon={MdSettings} />

        <Tabs defaultValue="account">
          <Tabs.List>
            <Tabs.Tab value="account">Account</Tabs.Tab>
            <Tabs.Tab value="users" leftSection={<FaUserShield />}>
              User Management
            </Tabs.Tab>
          </Tabs.List>

          <Tabs.Panel value="account" pt="lg">
            <Stack gap="md" maw={500}>
              <Title order={3}>Change Password</Title>

              {passwordMessage && (
                <Alert color={passwordMessage.type === 'success' ? 'green' : 'red'}>
                  {passwordMessage.text}
                </Alert>
              )}

              <form onSubmit={handlePasswordChange}>
                <Stack gap="md">
                  <PasswordInput
                    label="Current Password"
                    value={currentPassword}
                    onChange={(e) => setCurrentPassword(e.target.value)}
                    required
                  />
                  <PasswordInput
                    label="New Password"
                    value={newPassword}
                    onChange={(e) => setNewPassword(e.target.value)}
                    required
                  />
                  <PasswordInput
                    label="Confirm New Password"
                    value={confirmPassword}
                    onChange={(e) => setConfirmPassword(e.target.value)}
                    required
                  />
                  <Button type="submit" leftSection={<MdSave />}>
                    Update Password
                  </Button>
                </Stack>
              </form>
            </Stack>
          </Tabs.Panel>

          <Tabs.Panel value="users" pt="lg">
            <Stack gap="md">
              <Title order={3}>Manage User Roles</Title>

              <Text size="sm" c="dimmed">
                <strong>Read Only:</strong> Can view all pages but cannot create, edit, or delete<br />
                <strong>Limited:</strong> Cannot see payments page or manage users<br />
                <strong>Full:</strong> Can access all pages and make changes (except user management)<br />
                <strong>Admin:</strong> Full access including user role management
              </Text>

              <Table striped highlightOnHover>
                <Table.Thead>
                  <Table.Tr>
                    <Table.Th>Name</Table.Th>
                    <Table.Th>Email</Table.Th>
                    <Table.Th>Current Role</Table.Th>
                    <Table.Th>Change Role</Table.Th>
                  </Table.Tr>
                </Table.Thead>
                <Table.Tbody>
                  {users.map((user) => (
                    <Table.Tr key={user.id}>
                      <Table.Td>{user.name || 'N/A'}</Table.Td>
                      <Table.Td>{user.email}</Table.Td>
                      <Table.Td>
                        <Badge color={getRoleBadgeColor(user.role)}>
                          {user.role?.replace('_', ' ').toUpperCase() || 'FULL'}
                        </Badge>
                      </Table.Td>
                      <Table.Td>
                        <Select
                          data={ROLES}
                          value={user.role || 'full'}
                          onChange={(value) => handleRoleChange(user.id, value!)}
                          w={300}
                        />
                      </Table.Td>
                    </Table.Tr>
                  ))}
                </Table.Tbody>
              </Table>
            </Stack>
          </Tabs.Panel>
        </Tabs>
      </Paper>
    </Container>
  );
};
