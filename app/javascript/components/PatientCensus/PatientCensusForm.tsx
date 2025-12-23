import React, { useState } from "react";
import {
  Box,
  Button,
  Group,
  TextInput,
  Select,
  Textarea,
  NumberInput,
  Radio,
  MultiSelect,
  Stack,
  Card,
  Title,
  Notification,
  Flex,
  Grid,
  Divider,
  Container,
  SegmentedControl
} from "@mantine/core";
import { DateInput } from "@mantine/dates";
import { PatientCensusFormData } from "../types";
import axios from "axios";
import { FlaggedTitle } from "../Shared/FlaggedTitle";
import { FaUserPlus } from "react-icons/fa";

const PLAN_OPTIONS = [
  'TRT', 'Enclomiphene', 'Peptides', 'Semaglutide', 'Tirzepatide',
  'Gainswave', 'P-Shot', 'Trimix', 'Gonadorelin', 'Clomid',
  'Pellets', 'Vitamin Package', 'Peptide Bundle', 'Other SEE notes'
];

const LEAD_SOURCE_OPTIONS = [
  'Paradigm', 'Google', 'Referral', 'GD Web', 'FB/Insta',
  'Other See Notes', 'Clinic Transfer', 'Ground Marketing',
  'No Answer', 'Staff Referrals', 'TiffOKC', 'BigTre'
];

interface PatientCensusFormProps {
  onSuccess?: () => void;
}

export const PatientCensusForm: React.FC<PatientCensusFormProps> = ({ onSuccess }) => {
  const [formData, setFormData] = useState<PatientCensusFormData>({
    date: new Date().toISOString().split('T')[0],
    patient_name: '',
    patient_result: 'Win',
    rate: 100,
    mail_out_in_clinic: 'In Clinic',
    in_clinic_dose_ml: undefined,
    med_order_made: undefined,
    lab_call_scheduled: undefined,
    monthly_contract_made: undefined,
    annual_lab_contract: undefined,
    consents_signed: undefined,
    in_clinic_appt_made: undefined,
    mail_out_appt_made: undefined,
    notes: undefined,
    lead_source: undefined,
    plan_notes: undefined,
    extra_info: undefined,
    p_or_other: undefined,
    phone_number: undefined,
    why_a_loss: undefined
  });

  const [loading, setLoading] = useState(false);
  const [notification, setNotification] = useState<{ type: 'success' | 'error', message: string } | null>(null);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setNotification(null);

    try {
      await axios.post('/api/v1/patient_census_entries', { patient_census_entry: formData });
      setNotification({ type: 'success', message: 'Patient census entry created successfully!' });

      setFormData({
        date: new Date().toISOString().split('T')[0],
        patient_name: '',
        patient_result: 'Win',
        rate: 100
      });

      if (onSuccess) onSuccess();
    } catch (error) {
      setNotification({ type: 'error', message: 'Failed to create entry. Please try again.' });
    } finally {
      setLoading(false);
    }
  };

  const handlePatientResultChange = (value: 'Win' | 'Thinker' | 'Loss') => {
    setFormData(prev => ({
      ...prev,
      patient_result: value,
      // Clear conditional fields when switching result types
      mail_out_in_clinic: undefined,
      in_clinic_dose_ml: undefined,
      med_order_made: undefined,
      lab_call_scheduled: undefined,
      monthly_contract_made: undefined,
      annual_lab_contract: undefined,
      consents_signed: undefined,
      in_clinic_appt_made: undefined,
      mail_out_appt_made: undefined,
      notes: undefined,
      lead_source: undefined,
      plan_notes: undefined,
      extra_info: undefined,
      p_or_other: undefined,
      phone_number: undefined,
      why_a_loss: undefined
    }));
  };

  const renderWinFields = () => (
    <>
      <Grid.Col span={{ xs: 12, sm: 12}}>
        <Stack gap="xs">
          <Box component="label" style={{ fontSize: '14px', fontWeight: 500 }}>
            MailOut/InClinic <span style={{ color: 'red' }}>*</span>
          </Box>
          <SegmentedControl
            value={formData.mail_out_in_clinic || ''}
            onChange={(value) => setFormData(prev => ({ ...prev, mail_out_in_clinic: value as 'In Clinic' | 'Mail Out' }))}
            data={[
              { label: 'In Clinic', value: 'In Clinic' },
              { label: 'Mail Out', value: 'Mail Out' }
            ]}
          />
        </Stack>
      </Grid.Col>

        <Grid.Col span={{ xs: 12, sm: 6}}>
          <NumberInput
            label="In Clinic Dose (ml)"
            value={formData.in_clinic_dose_ml || ''}
            onChange={(value) => setFormData(prev => ({ ...prev, in_clinic_dose_ml: Number(value) || undefined }))}
            step={0.01}
            disabled={formData.mail_out_in_clinic !== 'In Clinic'}
          />
        </Grid.Col>

      <Grid.Col span={{ xs: 12, sm: 12 }}>
        <Radio.Group
          label="In Clinic Appt Made"
          value={formData.in_clinic_appt_made || ''}
          onChange={(value) => setFormData(prev => ({ ...prev, in_clinic_appt_made: value as any }))}
        >
          <Group mt="xs">
            <Radio value="Yes" label="Yes" />
            <Radio value="No" label="No" />
            <Radio value="OTHER-check Chrono" label="OTHER-check Chrono" />
          </Group>
        </Radio.Group>
      </Grid.Col>

      <Grid.Col span={{ xs: 12, sm: 12 }}>
        <Radio.Group
          label="Mail Out Appt Made"
          value={formData.mail_out_appt_made || ''}
          onChange={(value) => setFormData(prev => ({ ...prev, mail_out_appt_made: value as any }))}
        >
          <Group mt="xs">
            <Radio value="Yes" label="Yes" />
            <Radio value="No" label="No" />
            <Radio value="NA" label="NA" />
          </Group>
        </Radio.Group>
      </Grid.Col>


      <Grid.Col span={{ xs: 12, sm: 12 }}>
        <Radio.Group
          label="Med Order Made"
          value={formData.med_order_made || ''}
          onChange={(value) => setFormData(prev => ({ ...prev, med_order_made: value as any }))}
        >
          <Group mt="xs">
            <Radio value="Yes" label="Yes" />
            <Radio value="No" label="No" />
            <Radio value="NA" label="NA" />
          </Group>
        </Radio.Group>
      </Grid.Col>

      <Grid.Col span={{ xs: 12, sm: 12 }}>
        <Radio.Group
          label="Lab Call Scheduled"
          value={formData.lab_call_scheduled || ''}
          onChange={(value) => setFormData(prev => ({ ...prev, lab_call_scheduled: value as any }))}
        >
          <Group mt="xs">
            <Radio value="Yes" label="Yes" />
            <Radio value="No" label="No" />
            <Radio value="NA" label="NA" />
          </Group>
        </Radio.Group>
      </Grid.Col>

      <Grid.Col span={{ xs: 12, sm: 12 }}>
        <Radio.Group
          label="Monthly Contract Made"
          value={formData.monthly_contract_made || ''}
          onChange={(value) => setFormData(prev => ({ ...prev, monthly_contract_made: value as any }))}
        >
          <Group mt="xs">
            <Radio value="Yes" label="Yes" />
            <Radio value="No" label="No" />
            <Radio value="OTHER-check Chrono" label="OTHER-check Chrono" />
            <Radio value="Contract made on PP" label="Contract made on PP" />
          </Group>
        </Radio.Group>
      </Grid.Col>

      <Grid.Col span={{ xs: 12, sm: 12 }}>
        <Radio.Group
          label="Annual Lab Contract"
          value={formData.annual_lab_contract || ''}
          onChange={(value) => setFormData(prev => ({ ...prev, annual_lab_contract: value as any }))}
        >
          <Group mt="xs">
            <Radio value="Yes" label="Yes" />
            <Radio value="No" label="No" />
            <Radio value="OTHER-check Chrono" label="OTHER-check Chrono" />
          </Group>
        </Radio.Group>
      </Grid.Col>

      <Grid.Col span={{ xs: 12, sm: 12 }}>
        <Radio.Group
          label="Consents Signed"
          value={formData.consents_signed || ''}
          onChange={(value) => setFormData(prev => ({ ...prev, consents_signed: value as any }))}
        >
          <Group mt="xs">
            <Radio value="NA" label="NA" />
            <Radio value="Yes" label="Yes" />
            <Radio value="No" label="No" />
            <Radio value="OTHER-check Chrono" label="OTHER-check Chrono" />
            <Radio value="Sent Consent" label="Sent Consent" />
          </Group>
        </Radio.Group>
      </Grid.Col>

      
      <Grid.Col span={{ xs: 12, sm: 12 }}>
        <Textarea
          label="Notes"
          value={formData.notes || ''}
          onChange={(e) => setFormData(prev => ({ ...prev, notes: e.target.value }))}
          rows={3}
        />
      </Grid.Col>

      <Grid.Col span={{ xs: 12, sm: 6 }}>
        <Select
          label="Lead Source"
          data={LEAD_SOURCE_OPTIONS}
          value={formData.lead_source || ''}
          onChange={(value) => setFormData(prev => ({ ...prev, lead_source: value as any }))}
          required
        />
      </Grid.Col>

      <Grid.Col span={{ xs: 12, sm: 12 }}>
        <Textarea
          label="Plan Notes"
          value={formData.plan_notes || ''}
          onChange={(e) => setFormData(prev => ({ ...prev, plan_notes: e.target.value }))}
          rows={2}
        />
      </Grid.Col>

      <Grid.Col span={{ xs: 12, sm: 12 }}>
        <Textarea
          label="Extra Info"
          value={formData.extra_info || ''}
          onChange={(e) => setFormData(prev => ({ ...prev, extra_info: e.target.value }))}
          rows={2}
        />
      </Grid.Col>
    </>
  );

  const renderThinkerFields = () => (
    <>
      <Grid.Col span={{ xs: 12, sm: 6 }}>
        <TextInput
          label="P or Other?"
          value={formData.p_or_other || ''}
          onChange={(e) => setFormData(prev => ({ ...prev, p_or_other: e.target.value }))}
          required
        />
      </Grid.Col>

      <Grid.Col span={{ xs: 12, sm: 6 }}>
        <TextInput
          label="Phone Number"
          value={formData.phone_number || ''}
          onChange={(e) => setFormData(prev => ({ ...prev, phone_number: e.target.value }))}
          required
        />
      </Grid.Col>

      <Grid.Col span={{ xs: 12, sm: 12 }}>
        <Textarea
          label="Other Info"
          value={formData.extra_info || ''}
          onChange={(e) => setFormData(prev => ({ ...prev, extra_info: e.target.value }))}
          rows={3}
        />
      </Grid.Col>

      <Grid.Col span={{ xs: 12, sm: 12 }}>
        <Textarea
          label="Notes"
          value={formData.notes || ''}
          onChange={(e) => setFormData(prev => ({ ...prev, notes: e.target.value }))}
          rows={3}
        />
      </Grid.Col>
    </>
  );

  const renderLossFields = () => (
    <>
      <Grid.Col span={{ xs: 12, sm: 6 }}>
        <TextInput
          label="P or Other?"
          value={formData.p_or_other || ''}
          onChange={(e) => setFormData(prev => ({ ...prev, p_or_other: e.target.value }))}
          required
        />
      </Grid.Col>

      <Grid.Col span={{ xs: 12, sm: 12 }}>
        <Textarea
          label="Why a loss?"
          value={formData.why_a_loss || ''}
          onChange={(e) => setFormData(prev => ({ ...prev, why_a_loss: e.target.value }))}
          rows={3}
          required
        />
      </Grid.Col>
    </>
  );

  return (
    <Container size={"xl"}>
    <Card shadow="sm" padding="xl">
      <FlaggedTitle titleText="Patient Census" leftIcon={FaUserPlus} />

      {notification && (
        <Notification
          color={notification.type === 'success' ? 'green' : 'red'}
          onClose={() => setNotification(null)}
          mb="md"
        >
          {notification.message}
        </Notification>
      )}

      <form onSubmit={handleSubmit}>
        <Grid>
          

          <Grid.Col span={{ xs: 12, sm: 8 }}>
            <Grid>
          <Grid.Col span={{ xs: 12, sm: 6 }}>
            <TextInput
              label="First Name"
              value={formData.patient_name}
              onChange={(e) => setFormData(prev => ({ ...prev, patient_name: e.target.value }))}
              required
            />
          </Grid.Col>
          <Grid.Col span={{ xs: 12, sm: 6 }}>
            <TextInput
              label="Last Name"
              value={formData.patient_name}
              onChange={(e) => setFormData(prev => ({ ...prev, patient_name: e.target.value }))}
              required
            />
          </Grid.Col>
          <Grid.Col span={{ xs: 12, sm: 6 }}>
            <DateInput
              label="Date"
              value={new Date(formData.date)}
              onChange={(value) => setFormData(prev => ({
                ...prev,
                date: value ? value.toISOString().split('T')[0] : new Date().toISOString().split('T')[0]
              }))}
              required
            />
          </Grid.Col>

          <Grid.Col span={{ xs: 12, sm: 12 }}>
            <Divider my="sm" />
          </Grid.Col>


          <Grid.Col span={{ xs: 12, sm: 12 }}>
            <Stack gap="xs">
              <Box component="label" style={{ fontSize: '14px', fontWeight: 500 }}>
                Patient Result <span style={{ color: 'red' }}>*</span>
              </Box>
              <SegmentedControl
                value={formData.patient_result}
                color={formData.patient_result === 'Loss' ? 'red' : formData.patient_result === 'Win' ? 'green' : 'yellow'}
                onChange={(value: string) => handlePatientResultChange(value as 'Win' | 'Thinker' | 'Loss')}
                data={[
                  { label: 'Win', value: 'Win' },
                  { label: 'Thinker', value: 'Thinker' },
                  { label: 'Loss', value: 'Loss' }
                ]}
              />
            </Stack>
          </Grid.Col>

          <Grid.Col span={{ xs: 12, sm: 12 }}>
            <Divider my="sm" />
          </Grid.Col>


          <Grid.Col span={{ xs: 12, sm: 6 }}>
            <MultiSelect
              label="Plan"
              data={PLAN_OPTIONS}
              value={formData.plan || []}
              onChange={(value) => setFormData(prev => ({ ...prev, plan: value }))}
              searchable
            />
          </Grid.Col>


          {formData.patient_result !== 'Loss' && (
            <Grid.Col span={{ xs: 12, sm: 6 }}>
              <NumberInput
                label="Rate"
                value={formData.rate || 100}
                onChange={(value) => setFormData(prev => ({ ...prev, rate: Number(value) || 100 }))}
                prefix="$ "
                decimalScale={2}
                fixedDecimalScale
              />
            </Grid.Col>
          )}

          {formData.patient_result === 'Win' && renderWinFields()}
          {formData.patient_result === 'Thinker' && renderThinkerFields()}
          {formData.patient_result === 'Loss' && renderLossFields()}

          <Group justify="flex-end" mt="lg">
            <Button type="submit" loading={loading}>
              Save Entry
            </Button>
          </Group>
          </Grid>
          </Grid.Col>
          <Grid.Col span={{ xs: 12, sm: 8 }}>

          </Grid.Col>
        </Grid>
        
      </form>
    </Card>
    </Container>
  );
};