require 'rails_helper'

RSpec.describe "Admin Invoice Show Page" do
  before :each do
    @billman = Merchant.create!(name: "Billman", created_at: Time.now, updated_at: Time.now)

    @bracelet = @billman.items.create!(name: "Bracelet", description: "shiny", unit_price: 1001, created_at: Time.now, updated_at: Time.now)
    @mood = @billman.items.create!(name: "Mood Ring", description: "Moody", unit_price: 2002, created_at: Time.now, updated_at: Time.now)

    @customer_1 = Customer.create!(first_name: 'Joey', last_name: "Ondricka", created_at: Time.now, updated_at: Time.now)

    @invoice_1 = @customer_1.invoices.create!(status: "cancelled", created_at: Time.now, updated_at: Time.now)
    @invoice_2 = @customer_1.invoices.create!(status: "in progress", created_at: Time.now, updated_at: Time.now)

    @invoice_items_1 = @bracelet.invoice_items.create!(quantity: 1, unit_price: 1001, status: "Pending", invoice_id: @invoice_1.id, created_at: Time.now, updated_at: Time.now)
    @invoice_items_2 = @mood.invoice_items.create!(quantity: 1, unit_price: 2002, status: "Pending", invoice_id: @invoice_2.id, created_at: Time.now, updated_at: Time.now)

  end

  it "shows all attributes of an invoice" do
    visit "/admin/invoices/#{@invoice_1.id}"
    expect(page).to have_content("Invoice ID: #{@invoice_1.id}")
    expect(page).to have_content("Invoice Status: #{@invoice_1.status}")
    expect(page).to have_content("Invoice Created at: #{@invoice_1.created_at_format}")
    expect(page).to have_content("Customer Name: #{@customer_1.first_name} #{@customer_1.last_name}")
    expect(page).to_not have_content("Invoice ID: #{@invoice_2.id}")
    expect(page).to_not have_content("Invoice Status: #{@invoice_2.status}")
  end

  it "shows item attributes for items on an invoice" do
    visit "/admin/invoices/#{@invoice_1.id}"
    expect(page).to have_content("Item Name: Bracelet")
    expect(page).to have_content("Quantity: 1")
    expect(page).to have_content("Price Sold For: $10.01")
    expect(page).to have_content("Item Status: Pending")

    expect(page).to_not have_content("Item Name: Mood Ring")
    expect(page).to_not have_content("Price Sold For: $20.02")
  end
end