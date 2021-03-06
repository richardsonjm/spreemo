require 'rails_helper'

describe User do
  subject { create :user }

  it { is_expected.to be_valid }

  describe "database fields" do
    it { is_expected.to have_db_column(:email) }
    it { is_expected.to have_db_column(:first_name) }
    it { is_expected.to have_db_column(:last_name) }
  end

  describe '#email' do
    it { is_expected.to respond_to :email }
    it { is_expected.to validate_presence_of(:email) }

    context 'when valid' do
      before { subject.email = 'jondoe@person.com' }

      it { is_expected.to be_valid }
    end

    context 'when not valid' do
      before { subject.email = 'invalid_email' }

      it { is_expected.to_not be_valid }
    end
  end

  describe '#first_name' do
    it { is_expected.to respond_to :first_name }
    it { is_expected.to validate_presence_of(:first_name) }
  end

  describe '#last_name' do
    it { is_expected.to respond_to :last_name }
    it { is_expected.to validate_presence_of(:last_name) }
  end

  describe "addresses" do
    it { is_expected.to have_many :addresses }
    it { is_expected.to respond_to :addresses }
    it { is_expected.to respond_to :address_ids }
  end

  describe '#name' do
    let(:first_name) { subject.first_name }
    let(:last_name) { subject.last_name }
    let(:name) { subject.name }

    it 'includes #first_name' do
      expect(name.include?(first_name)).to be_truthy
    end

    it 'includes #last_name' do
      expect(name.include?(last_name)).to be_truthy
    end
  end

  describe 'patient' do
    before { subject.add_role :patient }

    context 'role' do
      it 'has patient role' do
        expect(subject.has_role? :patient).to be true
      end
    end

    context "patients_ailments" do
      it { is_expected.to have_many :patients_ailments }
      it { is_expected.to respond_to :patients_ailments }
      it { is_expected.to respond_to :patients_ailment_ids }
    end

    context "ailments" do
      it { is_expected.to have_many :ailments }
      it { is_expected.to respond_to :ailments }
      it { is_expected.to respond_to :ailment_ids }
    end

    describe "patient_appointments" do
      it { is_expected.to have_many :patient_appointments }
      it { is_expected.to respond_to :patient_appointments }
      it { is_expected.to respond_to :patient_appointment_ids }
    end

    describe "doctors" do
      it { is_expected.to have_many :doctors }
      it { is_expected.to respond_to :doctors }
      it { is_expected.to respond_to :doctor_ids }
    end

    describe "#ailment_specialty_ids" do
      it "returns arary of specialty_ids associated with ailments" do
        expect(subject.ailment_specialty_ids).to eq subject.ailments.map {|a| a.specialty_id}
      end
    end
  end

  describe 'doctor' do
    before { subject.add_role :doctor }

    context 'role' do
      it 'has doctor role' do
        expect(subject.has_role? :doctor).to be true
      end
    end

    context "doctors_specialties" do
      it { is_expected.to have_many :doctors_specialties }
      it { is_expected.to respond_to :doctors_specialties }
      it { is_expected.to respond_to :doctors_specialty_ids }
    end

    context "specialties" do
      it { is_expected.to have_many :specialties }
      it { is_expected.to respond_to :specialties }
      it { is_expected.to respond_to :specialty_ids }
    end

    context "doctor_appointments" do
      it { is_expected.to have_many :doctor_appointments }
      it { is_expected.to respond_to :doctor_appointments }
      it { is_expected.to respond_to :doctor_appointment_ids }
    end

    context "patients" do
      it { is_expected.to have_many :patients }
      it { is_expected.to respond_to :patients }
      it { is_expected.to respond_to :patient_ids }
    end

    context '#name' do
      let(:name) { subject.name }

      it 'starts with "Dr. "' do
        expect(name.starts_with?('Dr. ')).to be_truthy
      end
    end

    context "#name_and_specialties" do
      before do
        @specialty = FactoryGirl.create(:specialty)
        subject.specialties << @specialty
      end

      it "list speciatly after name" do
        expect(subject.name_and_specialties).to eq "#{subject.name} (#{@specialty.name})"
      end

      it "lists multiple speciatlies after name" do
        specialty2 = FactoryGirl.create(:specialty)
        subject.specialties << specialty2
        expect(subject.name_and_specialties).to eq "#{subject.name} (#{@specialty.name}, #{specialty2.name})"
      end
    end
  end

  describe "#self.patient_doctors" do
    before do
      specialties = FactoryGirl.create_list(:specialty, 3)
      ailments = specialties.map do |specialty|
        FactoryGirl.create(:ailment, specialty: specialty)
      end
      @patient = FactoryGirl.create(:patient, ailments: ailments[0..1])
      @patient_doctors = [0,1].map do |index|
        FactoryGirl.create(:ny_doctor, specialties: [specialties[index]])
      end
      other_doctors = FactoryGirl.create_list(:ny_doctor, 3, specialties: [specialties[2]])
    end

    it "returns doctors with specialties that match patient ailments" do
      expect(User.patient_doctors(@patient)).to eq @patient_doctors
    end
  end
end
