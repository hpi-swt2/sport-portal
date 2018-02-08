require 'rails_helper'
shared_examples 'a show event page' do |with: [], without: []|
  let(:with_content) { [] }
  subject { page }
  if with.include? :join_button
    it { is_expected.to have_link(:join_event_button) }

    it 'should redirect me to itself when clicking the join button' do
      click_link(:join_event_button)
      expect(current_path).to eq(event_path(event))
    end

    it 'should have a leave button after clicking the join button' do
      click_link(:join_event_button)
      expect(page).to have_link(:leave_event_button)
    end
  end

  if with.include? :team_join_button
    it { is_expected.to have_link(:join_event_button) }
  end

  if with.include? :team_leave_button
    it { is_expected.to have_link(:leave_event_button) }
  end

  if with.include? :leave_button
    it { is_expected.to have_link(:leave_event_button) }

    it 'should have a join button after clicking the leave button' do
      click_link(:leave_event_button)
      expect(page).to have_link(:join_event_button)
    end

    it 'should redirect me to itself when clicking the leave button' do
      click_link(:leave_event_button)
      expect(current_path).to eq(event_path(event))
    end
  end

  if with.include? :archive_button
    it { is_expected.to have_link (:archive_event_button)}
  end

  if without.include? :join_button
    it { is_expected.not_to have_link(:join_event_button) }
  end

  if without.include? :leave_button
    it { is_expected.not_to have_link(:leave_event_button) }
  end

  it 'has correct content' do
    with_content.each do |content|
      expect(page).to have_content content
    end
  end
end
