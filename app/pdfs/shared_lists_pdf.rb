class SharedListsPdf < Prawn::Document
  def initialize(schedules, list_title)
    super()
    font_path = Rails.root.join('public/fonts/ipaexg.ttf')
    font_families.update('IPAexGothic' => {
                           normal: font_path
                         })
    font('IPAexGothic')

    formatted_text [
      { text: "共有リスト：#{list_title}　", size: 20 },
      { text: "(#{Time.current.strftime('%Y/%-m/%-d')}時点)" }
    ]

    move_down 20

    table_data = [%w[予定名 周期 次回予定日 次々回予定日 予算]] +
                 schedules.map do |s|
                   [s.title,
                    s.notification_period.to_s,
                    s.next_notification.strftime('%Y/%-m/%-d'),
                    s.after_next_notification.strftime('%Y/%-m/%-d'),
                    s.price.to_s]
                 end
    table(table_data, header: true, row_colors: %w[F0F0F0 FFFFFF])
  end
end
