require 'mysql'

class OcsInventory
  def self.login=(login)
    @login = login
  end
  def self.pass=(pass)
    @pass = pass
  end
  def self.host=(host)
    @host = host
  end
  def self.db=(db)
    @dbname = db
  end

  def self.connect
    begin
      @db = Mysql.new(@host, @login, @pass, @dbname)
    rescue Mysql::Error
      puts "What a shame! We could not connect to database my lord. -_-;;"
      exit 1
    end
  end

  def self.get_license(interval)
    begin
      results = @db.query "select NAME,LASTCOME,WINOWNER,OSNAME,WINPRODKEY from hardware where LASTCOME > TIMESTAMP(DATE_SUB(NOW(), INTERVAL #{interval} day))"
      #puts "Number of licenses #{results.num_rows}"
      return results
      #results.each_hash do |row|
        #return row
        #puts "Name: #{row.NAME} : #{row.LASTCOME} : #{row.OSNAME} : #{row.WINPRODKEY}"
      #end
      results.free
    ensure
      @db.close
    end
  end
end
