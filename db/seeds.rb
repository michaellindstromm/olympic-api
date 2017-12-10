# ***********************************************************************
# ***********************************************************************

# Seeds database into the below tables.

# Sports
# Disciplines
# Events
# Countries
# Cities
# Olympics
# Athletes
# Medals

# The records are created by iterating over .csv and .txt files in the
# lib/seeds directory. Some normalization is direct contact with these
# files in order to negate sport and discipline duplication. All other
# normalization happens programatically during seeding. While seeding,
# all tables except 'medals', sql queries are used to ensure duplication
# is minimized and the correct association with necessarry indices are
# created correctly. Some manual hashes are created to serve the same
# purpose of non-duplication in order to help speed up the seeding 
# process.

# Normalizations:
#  - Special Characters are removed from country names.
#  - Athlete's without a firt name, last name, or neither first and last
#  have a '-' inserted in place, meaning all athletes without first or
#  last names use the same athlete_id
#  - Years are converted into date format

# Process Notes:
#  - During seeding athletes with apostrophes in their name have an extra
# apostrophe after the apostrophe in order for insertions to work. (Only
# one apostrophe is displayed in the Athletes table.)
#  - Some historical data was being lost during seeding due to historical
# IOC codes that are no longer in use. The IOCCOUNTRYCODES.csv and
# COUNTRYINFO.txt were updated accordingly. Without this nearly 20% of 
# historical records would be lost. 
#  
# Additional Notes:
#  -  If there ever is an athlete to win a medal with the exact same
# first name, last name, and gender, the way the athletes and the medals
# tables would need to be updated otherwise records will be lost for one
# of the athletes. However, this has never occured in the history of the
# Olympics so this is not accounted for.
#  - There may be some event duplication due to the slight discrepency in
# how events were historically labeled and how they are labeled in the 
# modern era. This is negated as much as possible, but there may be some
# separation of events where there should not be.

# ***********************************************************************
# ***********************************************************************

require 'csv'
require 'date'

root_path = './lib/seeds/'
city_data = root_path + 'CITIES.txt'
country_code_data = root_path + 'COUNTRYINFO.txt'
country_data = root_path + 'IOCCOUNTRYCODES.csv'
sport_data = root_path + 'SPORTS.csv'
summer_data = root_path + 'SUMMERMEDALS.csv'
winter_data = root_path + 'WINTERMEDALS.csv'


# POPULATE SPORTS TABLE
csv_text = File.read(summer_data)
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')

csv.each do |row|
    sport = row['Sport']
    discipline = row['Discipline']
    event = row ['Event']
    if Sport.exists?(:sport_name => sport)
    else
        s = Sport.new
        s.sport_name = row['Sport']
        s.save
    end

end

csv_text = File.read(winter_data)
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')

csv.each do |row|
    sport = row['Sport']
    if Sport.exists?(:sport_name => sport)
    else
        s = Sport.new
        s.sport_name = row['Sport']
        s.save
    end
end


# POPULATE DISCIPLINES TABLE
csv_text = File.read(summer_data)
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')

csv.each do |row|

    sport = row['Sport']
    discipline = row['Discipline']
    event = row ['Event']

    if Sport.find_by(sport_name: sport).disciplines.exists?(discipline_name: discipline)
    else
        s = Sport.find_by(sport_name: sport).id
        d = Discipline.new
        d.discipline_name = discipline
        d.sport_id = s
        d.save
    end
    

end

csv_text = File.read(winter_data)
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')

csv.each do |row|

    sport = row['Sport']
    discipline = row['Discipline']
    event = row ['Event']

    if Sport.find_by(sport_name: sport).disciplines.exists?(discipline_name: discipline)
    else
        s = Sport.find_by(sport_name: sport).id
        d = Discipline.new
        d.discipline_name = discipline
        d.sport_id = s
        d.save
    end

end


# POPULATE EVENTS TABLE
csv_text = File.read(summer_data)
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
count = 0
csv.each do |row|

    sport = row['Sport']
    discipline = row['Discipline']
    event = row['Event']
    gender = row['Gender']

    if Discipline.find_by(discipline_name: discipline).events.exists?(event_name: event, gender: gender)
    else
        e = Event.new
        e.event_name = event
        e.discipline_id = Discipline.find_by(discipline_name: discipline).id
        e.gender = gender
        e.save
    end
    

end

csv_text = File.read(winter_data)
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')

csv.each do |row|

    sport = row['Sport']
    discipline = row['Discipline']
    event = row['Event']
    gender = row['Gender']

    if Discipline.find_by(discipline_name: discipline).events.exists?(event_name: event, gender: gender)
    else
        e = Event.new
        e.event_name = event
        e.discipline_id = Discipline.find_by(discipline_name: discipline).id
        e.gender = row['Gender']
        e.save
    end

end



# POPULATE COUNTRIES TABLE
csv_text = File.read(country_data)
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')

csv.each do |row|
    country = row['Country']
    if country.include?("*")
        country.delete!("*")
    end
    c = Country.new
    c.country_name = country
    c.noc = row['Int Olympic Committee code']
    c.save
end


# POPULATE CITIES
cities_txt = File.read(city_data);
cities_txt.split(/\n/).each_with_index do |line, i|
    if i != 0
        row = line.split(":")
        c = City.new
        c.city_name = row[0]
        c.country_id = Country.find_by(noc: row[1]).id
        c.save
    end
end


# POPULATE OLYMPICS TABLE
csv_text = File.read(summer_data)
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')

olympics_summer_dict = Hash.new

csv.each do |row|

    if olympics_summer_dict[row['Year']]
    else
        olympics_summer_dict[row['Year']] = 1
        o = Olympic.new
        o.year = row['Year'].to_i
        o.season = 'Summer'
        o.city_id = City.find_by(city_name: row['City']).id
        o.save
    end

end

csv_text = File.read(winter_data)
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')

olympics_winter_dict = Hash.new

csv.each do |row|

    if olympics_winter_dict[row['Year']]
    else
        olympics_winter_dict[row['Year']] = 1
        o = Olympic.new
        o.year = row['Year'].to_i
        o.season = 'Winter'
        o.city_id = City.find_by(city_name: row['City']).id
        o.save
    end

end


# POPULATE ATHLETES TABLE
csv_text = File.read(summer_data)
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')

athlete_dict = Hash.new

csv.each do |row|

    first_name = '-'
    last_name = '-'
    gender = '-'

    if row['Athlete'].class != NilClass
        name = row['Athlete'].split(", ")
        if name[1].class == NilClass
            first_name = '-'
        else
            first_name = name[1]
        end
        last_name = name[0]
        gender = row['Gender']
    else 
        first_name = '-'
        last_name = '-'
        gender = row['Gender']
    end

    key = first_name + last_name + gender 

    if athlete_dict[key]
    
    else
        athlete_dict[key] = 1
        ath = Athlete.new
        ath.first_name = first_name
        ath.last_name = last_name
        ath.gender = gender
        ath.save
    end

end

csv_text = File.read(winter_data)
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')

csv.each do |row|

    first_name = '-'
    last_name = '-'
    gender = '-'

    if row['Athlete'].class != NilClass
        name = row['Athlete'].split(", ")
        if name[1].class == NilClass
            first_name = '-'
        else
            first_name = name[1]
        end
        last_name = name[0]
        gender = row['Gender']
    else 
        first_name = '-'
        last_name = '-'
        gender = row['Gender']
    end

    key = first_name + last_name + gender 

    if athlete_dict[key]
    
    else
        athlete_dict[key] = 1
        ath = Athlete.new
        ath.first_name = first_name
        ath.last_name = last_name
        ath.gender = gender
        ath.save
    end

end


# POPULATE MEDALS TABLE
csv_text = File.read(summer_data)
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')

csv.each do |row|

    sport = row['Sport']
    discipline = row['Discipline']
    event = row['Event']
    gender = row['Gender']
    noc = row['Country']
    year = row['Year'].to_i
    discipline_key = sport + discipline
    first_name = '-'
    last_name = '-'
    if row['Athlete'].class != NilClass

        name = row['Athlete'].split(", ")
        if name[1].class == NilClass
            first_name = '-'
        else
            first_name = name[1]
        end
        last_name = name[0]

    end

    m = Medal.new
    m.rank = row['Medal']
    m.event_id = Event.joins(:discipline).find_by('disciplines.discipline_name': discipline, 'events.event_name': event).id
    m.athlete_id = Athlete.find_by(first_name: first_name, last_name: last_name, gender: gender).id
    m.olympic_id = Olympic.find_by(year: year, season: 'Summer').id
    m.country_id = Country.find_by(noc: noc).id
    m.save

end

csv_text = File.read(winter_data)
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')

csv.each do |row|

    sport = row['Sport']
    discipline = row['Discipline']
    event = row['Event']
    gender = row['Gender']
    noc = row['Country']
    year = row['Year'].to_i

    discipline_key = sport + discipline
    first_name = '-'
    last_name = '-'
    if row['Athlete'].class != NilClass

        name = row['Athlete'].split(", ")
        if name[1].class == NilClass
            first_name = '-'
        else
            first_name = name[1]
        end
        last_name = name[0]

    end

    
    m = Medal.new
    m.rank = row['Medal']
    m.event_id = Event.joins(:discipline).find_by('disciplines.discipline_name': discipline, 'events.event_name': event).id
    m.athlete_id = Athlete.find_by(first_name: first_name, last_name: last_name, gender: gender).id
    m.olympic_id = Olympic.find_by(year: year, season: 'Winter').id
    m.country_id = Country.find_by(noc: noc).id
    m.save
    
    
end
