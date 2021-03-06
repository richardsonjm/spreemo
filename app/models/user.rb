class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :email, presence: true, email: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  has_many :addresses, inverse_of: :user
  accepts_nested_attributes_for :addresses, allow_destroy: true

  # Patient associations
  has_many :patients_ailments, foreign_key: :patient_id
  has_many :ailments, through: :patients_ailments
  has_many :doctor_appointments, class_name: "Appointment", foreign_key: :patient_id, inverse_of: :patient
  has_many :doctors, through: :doctor_appointments, foreign_key: :patient_id

  # Doctor associations
  has_many :doctors_specialties, foreign_key: :doctor_id
  has_many :specialties, through: :doctors_specialties
  has_many :patient_appointments, class_name: "Appointment",  foreign_key: :doctor_id, inverse_of: :doctor
  has_many :patients, through: :patient_appointments, foreign_key: :doctor_id

  def self.patient_doctors(patient)
    specialty_ids = patient.ailment_specialty_ids
    doctors = User.joins(:doctors_specialties).where(doctors_specialties: {specialty_id: specialty_ids})
    nearby_doctors_addresses = Address.where(address_type: 1, user_id: doctors.pluck(:id)).near(Address.home_for(patient))
    doctors.where(id: nearby_doctors_addresses.map(&:user_id))
  end

  def ailment_specialty_ids
    ailments.map {|ailment| ailment.specialty_id}
  end

  def name
    name = "#{first_name} #{last_name}"
    has_role?(:doctor) ? "Dr. #{name}" : name
  end

  def name_and_specialties
    "#{name} (#{specialties.map{|specialty| specialty.name}.join(", ")})"
  end
end
