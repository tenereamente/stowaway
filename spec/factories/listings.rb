# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :listing do
    price 1
    active false
    space nil
  end
end
