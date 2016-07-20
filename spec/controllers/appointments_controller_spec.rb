require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe AppointmentsController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # Appointment. As you add validations to Appointment, be sure to
  # adjust the attributes here as well.

  let(:patient) { FactoryGirl.create(:patient) }

  let(:doctor) { FactoryGirl.create(:doctor) }

  let(:valid_attributes) {
    FactoryGirl.attributes_for(:appointment).merge(doctor_id: doctor.id)
  }

  let(:invalid_attributes) {
    FactoryGirl.attributes_for(:appointment, date: "").merge(doctor_id: doctor.id)
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # AppointmentsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all appointments as @appointments" do
      appointment = Appointment.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:appointments)).to eq([appointment])
    end
  end

  describe "GET #show" do
    it "assigns the requested doctor as @doctor" do
      appointment = Appointment.create! valid_attributes
      get :show, {:id => appointment.to_param}, valid_session
      expect(assigns(:appointment)).to eq(appointment)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Appointment" do
        expect {
          post :create, {patient_id: patient.id,  :appointment => valid_attributes, format: :js}, valid_session
        }.to change(Appointment, :count).by(1)
      end

      it "assigns a newly created appointment as @appointment" do
        post :create, {patient_id: patient.id,  :appointment => valid_attributes, format: :js}, valid_session
        expect(assigns(:appointment)).to be_a(Appointment)
        expect(assigns(:appointment)).to be_persisted
      end

      it "sends new appointment emails" do
        expect {
          post :create, {patient_id: patient.id,  :appointment => valid_attributes, format: :js}, valid_session
        }.to change(ActionMailer::Base.deliveries, :count).by(2)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved appointment as @appointment" do
        post :create, {patient_id: patient.id,  :appointment => invalid_attributes, format: :js}, valid_session
        expect(assigns(:appointment)).to be_a_new(Appointment)
      end

      it "re-renders the 'new' template" do
        post :create, {patient_id: patient.id,  :appointment => invalid_attributes, format: :js}, valid_session
        expect(response).to render_template("create")
      end

      it "does not send new appointment emails" do
        expect {
          post :create, {patient_id: patient.id,  :appointment => invalid_attributes, format: :js}, valid_session
        }.not_to change(ActionMailer::Base.deliveries, :count)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) { FactoryGirl.attributes_for(:appointment) }

      it "updates the requested appointment" do
        appointment = Appointment.create! valid_attributes
        put :update, {:id => appointment.to_param, :appointment => new_attributes, format: :js}, valid_session
        appointment.reload
        expect(appointment.date.utc.to_s).to eq new_attributes[:date].utc.to_s
      end

      it "assigns the requested appointment as @appointment" do
        appointment = Appointment.create! valid_attributes
        put :update, {:id => appointment.to_param, :appointment => valid_attributes, format: :js}, valid_session
        expect(assigns(:appointment)).to eq(appointment)
      end
    end

    context "with invalid params" do
      it "assigns the appointment as @appointment" do
        appointment = Appointment.create! valid_attributes
        put :update, {:id => appointment.to_param, :appointment => invalid_attributes, format: :js}, valid_session
        expect(assigns(:appointment)).to eq(appointment)
      end

      it "re-renders the 'edit' template" do
        appointment = Appointment.create! valid_attributes
        put :update, {:id => appointment.to_param, :appointment => invalid_attributes, format: :js}, valid_session
        expect(response).to render_template("update")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested appointment" do
      appointment = Appointment.create! valid_attributes.merge(patient_id: patient.id)
      expect {
        delete :destroy, {:id => appointment.to_param}, valid_session
      }.to change(Appointment, :count).by(-1)
    end

    it "redirects to the appointments list" do
      appointment = Appointment.create! valid_attributes.merge(patient_id: patient.id)
      delete :destroy, {:id => appointment.to_param}, valid_session
      expect(response).to redirect_to patient_path(patient)
    end
  end
end