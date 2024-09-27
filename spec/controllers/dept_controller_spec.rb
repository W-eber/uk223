RSpec.describe DebtsController, type: :controller do
    let(:payer) { create(:user) }
    let(:payee) { create(:user) }
    let(:group) { create(:group) }
    let(:valid_session) { {} }
  
    describe "POST #create" do
      context "with valid parameters" do
        it "creates a new debt" do
          sign_in payer
          post :create, params: { group_id: group.id, debt: { amount: 100, description: 'Test Debt', payee_id: payee.id } }, session: valid_session
          expect(Debt.count).to eq(1)
        end
  
        it "redirects to the group page" do
          sign_in payer
          post :create, params: { group_id: group.id, debt: { amount: 100, description: 'Test Debt', payee_id: payee.id } }, session: valid_session
          expect(response).to redirect_to(group_path(group))
        end
      end
  
      context "with invalid parameters" do
        it "does not create a new debt" do
          sign_in payer
          post :create, params: { group_id: group.id, debt: { amount: nil, description: 'Test Debt', payee_id: payee.id } }, session: valid_session
          expect(Debt.count).to eq(0)
        end
  
        it "re-renders the new template" do
          sign_in payer
          post :create, params: { group_id: group.id, debt: { amount: nil, description: 'Test Debt', payee_id: payee.id } }, session: valid_session
          expect(response).to render_template("new")
        end
      end
    end
  
    describe "PATCH #update" do
      it "marks a debt as paid" do
        sign_in payer
        debt = create(:debt, group: group, payer: payer, payee: payee, is_paid: false)
        patch :update, params: { group_id: group.id, id: debt.id, mark_as_paid: true }, session: valid_session
        expect(debt.reload.is_paid).to eq(true)
      end
    end
  end
  