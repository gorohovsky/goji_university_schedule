module Validators
  class OverlapValidator < ActiveModel::Validator
    def check_for_overlaps(section, other_sections, &)
      SectionOverlapChecker.check(section, other_sections, &)
    end
  end
end
