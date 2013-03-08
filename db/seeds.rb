
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Review.destroy_all
Video.destroy_all
Category.destroy_all
User.destroy_all
QueueItem.destroy_all
Relationship.destroy_all

category_commedies = Category.create(name: 'TV Commedies')
category_dramas = Category.create(name: 'TV Dramas')
category_reality = Category.create(name: 'Reality TV')


video_family = Video.create(title: 'Family Guy', \
	description: 'Family Guy is an American animated sitcom created by Seth MacFarlane for the Fox Broadcasting Company. The series centers on the Griffins, a dysfunctional family consisting of parents Peter and Lois; their children Meg, Chris, and Stewie; and their anthropomorphic pet dog Brian. The show is set in the fictional city of Quahog, Rhode Island, and exhibits much of its humor in the form of cutaway gags that often lampoon American culture.', \
	small_cover_url: '/tmp/family_guy.jpg', \
	category: category_commedies)
video_futurama = Video.create(title: 'Futurama', \
	description: 'Futurama is an American animated science fiction sitcom created by Matt Groening and developed by Groening and David X. Cohen for the Fox Broadcasting Company. The series follows the adventures of a late-20th-century New York City pizza delivery boy, Philip J. Fry, who, after being unwittingly cryogenically frozen for one thousand years, finds employment at Planet Express, an interplanetary delivery company in the retro-futuristic 31st century. The series was envisioned by Groening in the late 1990s while working on The Simpsons, later bringing Cohen aboard to develop storylines and characters to pitch the show to Fox.', \
 	small_cover_url: '/tmp/futurama.jpg', \
	category: category_commedies)
video_monk = Video.create(title: 'Monk', \
	description: 'Monk is an American comedy-drama detective mystery television series created by Andy Breckman and starring Tony Shalhoub as the eponymous character, Adrian Monk. It originally ran from 2002 to 2009 and is primarily a mystery series, although it has dark and comic touches. The series was produced by Mandeville Films and Touchstone Television (although the corporate name changed to ABC Studios in the course of the series, the Touchstone Television logo remained throughout, making Monk the last surviving series to carry it) in association with Universal Television.', \
	small_cover_url: '/tmp/monk.jpg', \
	large_cover_url: '/tmp/monk_large.jpg', \
	category: category_dramas)
video_south_park = Video.create(title: 'South Park', \
	description: 'South Park is an American animated sitcom created by Trey Parker and Matt Stone for the Comedy Central television network. Intended for mature audiences, the show has become famous for its crude language and dark, surreal humor that lampoons a wide range of topics. The ongoing narrative revolves around four boys-Stan Marsh, Kyle Broflovski, Eric Cartman and Kenny McCormick-and their bizarre adventures in and around the titular Colorado town.', \
	small_cover_url: '/tmp/south_park.jpg', \
	category: category_commedies)

user_alex = User.create(email: "alex@bibiano.es", password: "1234", full_name: "Alex Bibiano")
user_chris = User.create(email: "chris@example.com", password: "1234", full_name: "Chris")
user_peter = User.create(email: "peter@example.com", password: "1234", full_name: "Peter")

all_users = Array.new
all_users << user_alex << user_chris << user_peter

(1..10).each { all_users << Fabricate(:user) }

(1..100).each { Review.create(content: Faker::Lorem.paragraph(3), rating: Random.rand(1..5), user: all_users.sample, video: [video_family, video_futurama, video_monk, video_south_park].sample) }

user_alex.queue_items.create(video: video_south_park, position: 1)
user_alex.queue_items.create(video: video_monk, position: 2)

user_alex.relationships.create(followed_id: user_peter.id)
user_alex.relationships.create(followed_id: user_chris.id)

user_peter.relationships.create(followed_id: user_chris.id)
user_peter.relationships.create(followed_id: user_alex.id)