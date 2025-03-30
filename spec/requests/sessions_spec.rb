require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "POST /login" do
    let(:user) { create(:user, password: 'password') }

    context "ログイン成功時" do
      it "リダイレクトされてメッセージが表示される" do
        post login_path, params: { email: user.email, password: 'password' }

        expect(response).to redirect_to(schedules_path)
        follow_redirect!
        expect(response.body).to include("ログインに成功しました。")
      end
    end

    context "パスワードが間違っている場合" do
      it "エラーメッセージが表示される" do
        post login_path, params: { email: user.email, password: 'wrongpassword' }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("ログインに失敗しました。")
      end
    end

    context "crypted_password が nil の場合" do
      let(:incomplete_user) { create(:user, password: 'password', password_confirmation: 'password') }

      before do
        incomplete_user.update_columns(crypted_password: nil, salt: nil)
      end

      it "登録未完了のためメッセージが表示される" do
        post login_path, params: { email: incomplete_user.email, password: 'password' }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("登録を完了させて下さい。")
      end
    end
  end
end
