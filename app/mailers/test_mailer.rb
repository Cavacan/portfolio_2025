class TestMailer < ApplicationMailer
  def sample_email
    mail(
      to: 'test@example.com',
      from: 'noreply@example.com',
      subject: 'これはテストメールです'
    ) do |format|
      format.text { render plain: 'テストメールの本文です。' }
    end
  end
end
