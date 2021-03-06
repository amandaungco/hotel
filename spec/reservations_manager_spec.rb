require_relative 'spec_helper'
require 'pry'
# require 'Date'

describe "ReservationManager" do
  before do
    @hotel_ada = Hotel::ReservationManager.new(20)
    @dateA = '2018-08-09'
    @dateB = '2018-08-15'
    @dateC = '2018-08-20'
    @dateD = '2018-08-23'
    @dateE ='2018-08-25'
    @dateF = '2018-08-27'
    @test_date = '2018-08-20'

    @new_reservation1 = @hotel_ada.reserve_room(@dateA, @dateC)
    @new_reservation2 = @hotel_ada.reserve_room(@dateB, @dateD)
    @new_reservation3 = @hotel_ada.reserve_room(@dateE, @dateF)
    @new_reservation4 = @hotel_ada.reserve_room(@dateA, @dateD)
    @new_reservation5 = @hotel_ada.reserve_room(@dateC, @dateD)
  end

  describe "Initialize ReservationsManager" do
    it "is an instance of Hotel::ReservationsManager" do
      expect(@hotel_ada).must_be_instance_of Hotel::ReservationManager
      expect(@hotel_ada.reservations).must_be_kind_of Array
    end

    it "raise an argumenterror for invalid date range" do
      expect {
        @hotel_ada.reserve_room(@dateD, @dateC)
      }.must_raise ArgumentError
      expect {
        @hotel_ada.reserve_room(@dateD, @dateD)
      }.must_raise ArgumentError
    end
  end

  describe "Access all rooms" do
    it "returns a list of all rooms" do
      expect(@hotel_ada.rooms.count).must_equal 20
      expect(@hotel_ada.rooms).must_be_kind_of Array
      expect(@hotel_ada.rooms[0]).must_be_instance_of Hotel::Room
    end
  end


  describe "reserve_room ReservationManager" do
    it "can reserve a room for a given date range" do
      expect(@new_reservation1).must_be_instance_of Hotel::Reservation
      #binding.pry
      expect(@new_reservation1.id).must_equal 1
      expect(@new_reservation5.id).must_equal 5
      expect(@new_reservation1.check_in).must_be_instance_of Date
    end

    it "adds room id to the reservation" do
      expect(@new_reservation1.rooms).must_be_kind_of Array
      expect(@new_reservation1.rooms[0]).must_equal 20
      expect(@new_reservation5.rooms[0]).must_equal 17 # llook for room with availability conflict
    end

    it "adds the reservation to the instance of room" do
      expect(@hotel_ada.rooms[0].reservations).must_be_kind_of Array
      expect(@hotel_ada.rooms[19].reservations[0]).must_be_instance_of Hotel:: Reservation
      expect(@hotel_ada.rooms[19].reservations[0].id).must_equal 1
    end
  end

  describe "it can list all reservations for a given date" do

    it "returns a list of rooms for given date" do
      expect(@hotel_ada.booked_reservations(@test_date)).must_be_kind_of Array
      #binding.pry
      expect(@hotel_ada.booked_reservations(@test_date)[0]).must_be_instance_of Hotel::Reservation
      expect(@hotel_ada.booked_reservations(@test_date).length).must_equal 3
    end
  end

  describe "Wave 2 - Return list of available rooms for given date range" do
    it "returns a list of availble rooms for given date" do
      expect(@hotel_ada.available_rooms('2018-08-20', '2018-08-23')).must_be_kind_of Array
      #binding.pry
      expect(@hotel_ada.available_rooms('2018-08-20', '2018-08-23').length).must_equal 16
      expect(@hotel_ada.available_rooms('2018-08-20', '2018-08-23')[0]).must_be_kind_of Hotel::Room
      #expect(@hotel_ada.available_rooms("08.23.2018", "08.25.2018")[0].id).must_equal #rooom ID
    end
  end

  describe "Wave 3 - Reserve Block rooms" do
    before do
      @many_rooms_test = @hotel_ada.reserve_room('2018-08-20', '2018-08-23', number_of_rooms: 3)
      @block = @hotel_ada.create_block('2018-08-20', '2018-08-23', number_of_rooms: 10, discount_rate: 0.8)
      @block_reservation = @hotel_ada.reserve_room('2018-08-20', '2018-08-23', number_of_rooms: 2, block_id: 1) #:block_id
    end

    it "allows you to reserve multiple rooms on one reservation" do
      expect(@many_rooms_test).must_be_instance_of Hotel::Reservation
      expect(@many_rooms_test.id).must_equal 6
      expect(@many_rooms_test.rooms.length).must_equal 3
      expect(@many_rooms_test.total_cost).must_equal 1800
    end

    it "can block a given amount of rooms over a date range" do
      expect(@block).must_be_instance_of Hotel::Block
      expect(@block.reservations).must_be_kind_of Array
      expect(@block.rooms).must_be_kind_of Array
      expect(@block.rooms[0]).must_be_kind_of Integer
      expect(@block.rooms.length).must_equal 10
      expect(@block.date_range.count).must_equal 3
    end

    it "allows you to make multiple reservation in a block of rooms" do

    expect(@block.reservations[0]).must_be_instance_of Hotel::Reservation
    end
  end

end



# describe "List all rooms "
