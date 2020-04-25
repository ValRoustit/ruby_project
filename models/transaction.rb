require_relative('../db/sql_runner')

class Transaction
    attr_reader :id
    attr_accessor :name, :amount, :merchant_id, :tag_id

    def initialize( options )
        @id = options['id'].to_i if options['id']
        @name = options['name']
        @amount = options['amount']
        @merchant_id = options['merchant_id'].to_i
        @tag_id = options['tag_id'].to_i
    end

    def save()
        sql = "INSERT INTO transactions (name, amount, merchant_id, tag_id) VALUES ($1, $2, $3, $4) RETURNING id"
        values = [@name, @amount, @merchant_id, @tag_id]
        transaction = SqlRunner.run(sql, values)[0]
        @id = transaction['id'].to_i
    end


    def delete()
        sql = "DELETE FROM transactions WHERE id = $1"
        values = [@id]
        SqlRunner.run(sql, values)
    end

    def self.delete_all()
        sql = "DELETE FROM transactions"
        SqlRunner.run(sql)
    end

    def self.map_items(transaction_data)
        return transaction_data.map { |transaction| Transaction.new(transaction) }
    end
end