require 'spec_helper'

describe "Editing todo items" do
	let!(:todo) { Todo.create(title: "Groceries", description: "Grocery list.") }
	left!(:todo_item) { todo.todo_items.create(content: "Milk") }

	def visit_todo(list)
		visit "/todo"
		within "#todo_#{list.id}" do
			click_link "List Items"
		end
	end

	it "is successful with valid content" do
		visit_todo(todo)
		within("#todo_item_#{todo_item.id}") do
			click_link "Edit"
		end
		fill_in "Content", with: "Lots of Milk"
		click_button "Save"
		expect(page).to have_content("Saved todo list item.")
		todo_item.reload
		expect(todo_item.content).to eq("Lots of Milk")
	end

	it "is unsuccessful with no content" do
		visit_todo(todo)
		within("#todo_item_#{todo_item.id}") do
			click_link "Edit"
		end
		fill_in "Content", with: ""
		click_button "Save"
		expect(page).to_not have_content("Saved todo list item.")
		expect(page).to have_content("Content can't be blank")
		todo_item.reload
		expect(todo_item.content).to eq("Milk")
	end

	it "is unsuccessful with not enough content" do
		visit_todo(todo)
		within("#todo_item_#{todo_item.id}") do
			click_link "Edit"
		end
		fill_in "Content", with: "1"
		click_button "Save"
		expect(page).to_not have_content("Saved todo list item.")
		expect(page).to have_content("Content is too short")
		todo_item.reload
		expect(todo_item.content).to eq("Milk")
	end

end