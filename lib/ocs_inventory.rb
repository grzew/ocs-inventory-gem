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

# Types:
#  1 - Windows KEY
#  2 - Microfoft Office

  def self.get_WINlicense(interval)
    self.connect
    begin
      results = @db.query "select NAME,LASTCOME,WINOWNER,OSNAME,WINPRODKEY from hardware where LASTCOME > TIMESTAMP(DATE_SUB(NOW(), INTERVAL #{interval} day))"
      return results
    ensure
      @db.close
    end
  end

  def self.get_OFFICElicense(version)
    self.connect
    begin
      results = @db.query "select HARDWARE_ID,PRODUCT,OFFICEKEY from officepack where OFFICEVERSION = #{version}"
      return results
    ensure
      @db.close
    end
  end
end
