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

RSpec.describe SpecialtiesController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Specialty. As you add validations to Specialty, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    FactoryGirl.attributes_for(:specialty)
  }

  let(:invalid_attributes) {
    FactoryGirl.attributes_for(:specialty, name: "")
  }

  describe 'as a patient' do
    before { sign_in FactoryGirl.create(:patient)}

    describe "GET #index" do
      it "assigns all specialties as @specialties" do
        specialty = Specialty.first
        get :index, {}
        expect(assigns(:specialties)).to eq([specialty])
      end
    end

    describe "GET #show" do
      it "assigns the requested specialty as @specialty" do
        specialty = Specialty.create! valid_attributes
        get :show, {:id => specialty.to_param}
        expect(assigns(:specialty)).to eq(specialty)
      end
    end
  end

  describe 'as an admin' do
    before { sign_in FactoryGirl.create(:admin)}

    describe "GET #new" do
      it "assigns a new specialty as @specialty" do
        get :new, {}
        expect(assigns(:specialty)).to be_a_new(Specialty)
      end
    end

    describe "GET #edit" do
      it "assigns the requested specialty as @specialty" do
        specialty = Specialty.create! valid_attributes
        get :edit, {:id => specialty.to_param}
        expect(assigns(:specialty)).to eq(specialty)
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new Specialty" do
          expect {
            post :create, {:specialty => valid_attributes}
          }.to change(Specialty, :count).by(1)
        end

        it "assigns a newly created specialty as @specialty" do
          post :create, {:specialty => valid_attributes}
          expect(assigns(:specialty)).to be_a(Specialty)
          expect(assigns(:specialty)).to be_persisted
        end

        it "redirects to the created specialty" do
          post :create, {:specialty => valid_attributes}
          expect(response).to redirect_to(Specialty.last)
        end
      end

      context "with invalid params" do
        it "assigns a newly created but unsaved specialty as @specialty" do
          post :create, {:specialty => invalid_attributes}
          expect(assigns(:specialty)).to be_a_new(Specialty)
        end

        it "re-renders the 'new' template" do
          post :create, {:specialty => invalid_attributes}
          expect(response).to render_template("new")
        end
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) {
          {name: "Newologist"}
        }

        it "updates the requested specialty" do
          specialty = Specialty.create! valid_attributes
          put :update, {:id => specialty.to_param, :specialty => new_attributes}
          specialty.reload
          expect(specialty.name).to eq  new_attributes[:name]
        end

        it "assigns the requested specialty as @specialty" do
          specialty = Specialty.create! valid_attributes
          put :update, {:id => specialty.to_param, :specialty => valid_attributes}
          expect(assigns(:specialty)).to eq(specialty)
        end

        it "redirects to the specialty" do
          specialty = Specialty.create! valid_attributes
          put :update, {:id => specialty.to_param, :specialty => valid_attributes}
          expect(response).to redirect_to(specialty)
        end
      end

      context "with invalid params" do
        it "assigns the specialty as @specialty" do
          specialty = Specialty.create! valid_attributes
          put :update, {:id => specialty.to_param, :specialty => invalid_attributes}
          expect(assigns(:specialty)).to eq(specialty)
        end

        it "re-renders the 'edit' template" do
          specialty = Specialty.create! valid_attributes
          put :update, {:id => specialty.to_param, :specialty => invalid_attributes}
          expect(response).to render_template("edit")
        end
      end
    end

    describe "DELETE #destroy" do
      it "destroys the requested specialty" do
        specialty = Specialty.create! valid_attributes
        expect {
          delete :destroy, {:id => specialty.to_param}
        }.to change(Specialty, :count).by(-1)
      end

      it "redirects to the specialties list" do
        specialty = Specialty.create! valid_attributes
        delete :destroy, {:id => specialty.to_param}
        expect(response).to redirect_to(specialties_url)
      end
    end
  end
end
