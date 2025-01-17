module SectionOverlapChecker
  def self.check(section, other_sections)
    other_sections.each do |other_section|
      next unless section.overlaps? other_section

      yield other_section
    end
  end
end
