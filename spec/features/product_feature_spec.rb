require 'rails_helper'

RSpec.describe "Products", type: :feature do
  before do
    Product.destroy_all
    Customer.destroy_all
    Invoice.destroy_all
    Order.destroy_all
  end

  describe "creating products" do
    it 'shows created product and does not redirect', js: :true do
      visit new_product_path
      fill_in "Name", with: "New Product"
      fill_in "Price", with: "2"
      fill_in "Description", with: "This is a very nice product!"
      click_button "submit"
      expect(page.current_path).to eq new_product_path
      expect(page).to have_content "New Product"
      expect(page).to have_content "2"
      expect(page).to have_content "This is a very nice product!"
    end
  end

  describe "products show" do
    it 'requires javascript to go next' do
      p1 = Product.create!(name: "Test Product", inventory: 0, description: "This is a test description with more text than should be there.", price: "2.99")
      p2 = Product.create!(name: "Test Product 2", inventory: 1, description: "This is a second test description with more text than should be there.", price: "1.99")

      visit product_path(p1)
      expect(page).to have_content p1.name
      click_link "Next Product"
      expect(page).not_to have_content p2.name
    end

    
  end

  describe "products index" do
    it 'gets the description and inventory', js: true do
      product = Product.create!(name: "Test Product", inventory: 0, description: "This is a test description with more text than should be there.")
      customer = Customer.create(:name => Faker::Name.name)
      invoice = Invoice.create
      order = Order.create(customer: customer, invoice: invoice)

      order.products << product
      visit products_path
      expect(page).to have_content(product.name, count: 1)
      expect(page).not_to have_content product.description
      click_button "More Info"
      expect(page).to have_content product.description
      expect(page).to have_content "Sold Out"
      product.inventory = 1
      product.save
      visit products_path
      click_button "More Info"
      expect(page).to have_content "Available"
    end
  end
end
