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
  Notification
} from "@mantine/core";
import { DateInput } from "@mantine/dates";
import { PatientCensusFormData } from "../types";
import axios from "axios";

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
  });
  
  const [loading, setLoading] = useState(false);
  const [notification, setNotification] = useState<{type: 'success' | 'error', message: string} | null>(null);

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
      <Radio.Group
        label="MailOut/InClinic"
        value={formData.mail_out_in_clinic || ''}
        onChange={(value) => setFormData(prev => ({ ...prev, mail_out_in_clinic: value as 'In Clinic' | 'Mail Out' }))}
        required
      >
        <Group>
          <Radio value="In Clinic" label="In Clinic" />
          <Radio value="Mail Out" label="Mail Out" />
        </Group>
      </Radio.Group>

      <NumberInput
        label="In Clinic Dose (ml)"
        value={formData.in_clinic_dose_ml || ''}
        onChange={(value) => setFormData(prev => ({ ...prev, in_clinic_dose_ml: Number(value) || undefined }))}
        step={0.01}
      />

      <Select
        label="Med Order Made"
        data={['Yes', 'No', 'NA']}
        value={formData.med_order_made || ''}
        onChange={(value) => setFormData(prev => ({ ...prev, med_order_made: value as any }))}
      />

      <Select
        label="Lab Call Scheduled"
        data={['Yes', 'No', 'NA']}
        value={formData.lab_call_scheduled || ''}
        onChange={(value) => setFormData(prev => ({ ...prev, lab_call_scheduled: value as any }))}
      />

      <Select
        label="Monthly Contract Made"
        data={['Yes', 'No', 'OTHER-check Chrono', 'Contract made on PP']}
        value={formData.monthly_contract_made || ''}
        onChange={(value) => setFormData(prev => ({ ...prev, monthly_contract_made: value as any }))}
      />

      <Select
        label="Annual Lab Contract"
        data={['Yes', 'No', 'OTHER-check Chrono']}
        value={formData.annual_lab_contract || ''}
        onChange={(value) => setFormData(prev => ({ ...prev, annual_lab_contract: value as any }))}
      />

      <Select
        label="Consents Signed"
        data={['NA', 'Yes', 'No', 'OTHER-check Chrono', 'Sent Consent']}
        value={formData.consents_signed || ''}
        onChange={(value) => setFormData(prev => ({ ...prev, consents_signed: value as any }))}
      />

      <Select
        label="In Clinic Appt Made"
        data={['Yes', 'No', 'OTHER-check Chrono']}
        value={formData.in_clinic_appt_made || ''}
        onChange={(value) => setFormData(prev => ({ ...prev, in_clinic_appt_made: value as any }))}
      />

      <Select
        label="Mail Out Appt Made"
        data={['Yes', 'No', 'NA']}
        value={formData.mail_out_appt_made || ''}
        onChange={(value) => setFormData(prev => ({ ...prev, mail_out_appt_made: value as any }))}
      />

      <Textarea
        label="Notes"
        value={formData.notes || ''}
        onChange={(e) => setFormData(prev => ({ ...prev, notes: e.target.value }))}
        rows={3}
      />

      <Select
        label="Lead Source"
        data={LEAD_SOURCE_OPTIONS}
        value={formData.lead_source || ''}
        onChange={(value) => setFormData(prev => ({ ...prev, lead_source: value as any }))}
        required
      />

      <Textarea
        label="Plan Notes"
        value={formData.plan_notes || ''}
        onChange={(e) => setFormData(prev => ({ ...prev, plan_notes: e.target.value }))}
        rows={2}
      />

      <Textarea
        label="Extra Info"
        value={formData.extra_info || ''}
        onChange={(e) => setFormData(prev => ({ ...prev, extra_info: e.target.value }))}
        rows={2}
      />
    </>
  );

  const renderThinkerFields = () => (
    <>
      <TextInput
        label="P or Other?"
        value={formData.p_or_other || ''}
        onChange={(e) => setFormData(prev => ({ ...prev, p_or_other: e.target.value }))}
        required
      />

      <TextInput
        label="Phone Number"
        value={formData.phone_number || ''}
        onChange={(e) => setFormData(prev => ({ ...prev, phone_number: e.target.value }))}
        required
      />

      <Textarea
        label="Other Info"
        value={formData.extra_info || ''}
        onChange={(e) => setFormData(prev => ({ ...prev, extra_info: e.target.value }))}
        rows={3}
      />

      <Textarea
        label="Notes"
        value={formData.notes || ''}
        onChange={(e) => setFormData(prev => ({ ...prev, notes: e.target.value }))}
        rows={3}
      />
    </>
  );

  const renderLossFields = () => (
    <>
      <TextInput
        label="P or Other?"
        value={formData.p_or_other || ''}
        onChange={(e) => setFormData(prev => ({ ...prev, p_or_other: e.target.value }))}
        required
      />

      <Textarea
        label="Why a loss?"
        value={formData.why_a_loss || ''}
        onChange={(e) => setFormData(prev => ({ ...prev, why_a_loss: e.target.value }))}
        rows={3}
        required
      />
    </>
  );

  return (
    <Card shadow="sm" padding="lg">
      <Title order={2} mb="lg">New Patient Census Entry</Title>
      
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
        <Stack>
          <DateInput
            label="Date"
            value={new Date(formData.date)}
            onChange={(value) => setFormData(prev => ({ 
              ...prev, 
              date: value ? value.toISOString().split('T')[0] : new Date().toISOString().split('T')[0] 
            }))}
            required
          />

          <TextInput
            label="Patient Name"
            value={formData.patient_name}
            onChange={(e) => setFormData(prev => ({ ...prev, patient_name: e.target.value }))}
            required
          />

          <Radio.Group
            label="Patient Result"
            value={formData.patient_result}
            onChange={(value: string) => handlePatientResultChange(value as 'Win' | 'Thinker' | 'Loss')}
            required
          >
            <Group>
              <Radio value="Win" label="Win" />
              <Radio value="Thinker" label="Thinker" />
              <Radio value="Loss" label="Loss" />
            </Group>
          </Radio.Group>

          <MultiSelect
            label="Plan"
            data={PLAN_OPTIONS}
            value={formData.plan || []}
            onChange={(value) => setFormData(prev => ({ ...prev, plan: value }))}
            searchable
          />

          {formData.patient_result !== 'Loss' && (
            <NumberInput
              label="Rate"
              value={formData.rate || 100}
              onChange={(value) => setFormData(prev => ({ ...prev, rate: Number(value) || 100 }))}
            />
          )}

          {formData.patient_result === 'Win' && renderWinFields()}
          {formData.patient_result === 'Thinker' && renderThinkerFields()}
          {formData.patient_result === 'Loss' && renderLossFields()}

          <Group justify="flex-end" mt="lg">
            <Button type="submit" loading={loading}>
              Save Entry
            </Button>
          </Group>
        </Stack>
      </form>
    </Card>
  );
};