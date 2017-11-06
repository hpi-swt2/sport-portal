module ButtonHelper
  def back_btn
    link_to t('helpers.links.back'), :back, :class => 'btn btn-default'
  end
end