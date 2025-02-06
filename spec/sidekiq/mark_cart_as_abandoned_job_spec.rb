require 'rails_helper'

RSpec.describe MarkCartAsAbandonedJob, type: :job do
  it "calls the CartAbandonmentService to mark and remove abandoned carts" do
    expect(CartAbandonmentService).to receive(:call)
    described_class.new.perform
  end
end