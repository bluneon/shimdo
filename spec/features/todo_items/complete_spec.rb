require 'spec_helper'

describe "Editing todo items" do
	let!(:todo) { Todo.create(title: "Groceries", description: "Grocery list.") }
	left!(:todo_item) { todo.todo_items.create(content: "Milk") }

	it "is successful when marking a single item complete" do
		expect(todo_item.completed_at).to be_nil
		visit_todo_list todo
		within dom_id_for(todo_item) do
			click_link "Mark complete"
		end
		todo_item.reload
		expect(todo_item.completed_at).to_not be_nil
	end
end