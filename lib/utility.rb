module UtilityMethods
  def increment(hash, value)
    if hash[value].nil?
      hash[value] = 1
    else
      hash[value] += 1
    end
  end
end
