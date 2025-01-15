shared_examples 'successful creation' do
  specify 'a new section is created' do
    expect { subject }.to change { Section.count }.by 1
  end
end

shared_examples 'creation error' do
  specify 'no new section is created' do
    expect { subject }.not_to change { Section.count }
  end

  specify 'the new section contains a corresponding error' do
    subject
    expect(new_section.errors.messages).to eq error_message
  end
end

shared_examples 'successful update' do |updated_attribute|
  specify 'the section is updated' do
    expect { subject }.to change(updated_section.reload, updated_attribute)
  end
end

shared_examples 'update error' do
  specify 'the section is not updated' do
    initial_state = updated_section.clone
    subject
    expect(updated_section.reload).to eq initial_state
  end

  specify 'the section contains a corresponding error' do
    subject
    expect(updated_section.errors.messages).to eq error_message
  end
end
