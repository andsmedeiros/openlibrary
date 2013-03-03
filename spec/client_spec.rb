require 'spec_helper'

describe 'Client' do
  let(:client)  { Openlibrary::Client.new() }

  describe '#new' do
    it 'requires an argument' do
      expect { Openlibrary::Client.new(nil) }.
        to raise_error ArgumentError, "Options hash required."
    end

    it 'requires a hash argument' do
      expect { Openlibrary::Client.new('foo') }.
        to raise_error ArgumentError, "Options hash required."
    end
  end

  describe '#book' do
    before do
      olid = 'OL23109860M'
      stub_get("/books/#{olid}", 'book.json')
    end
    it 'returns book details' do
      expect { client.book('OL23109860M') }.not_to raise_error

      book = client.book('OL23109860M')

      book.should be_a Hashie::Mash
      book.contributors.should be_a Array
      book.covers.should be_a       Array
      book.works.should be_a        Array

      book.title.should eq                    'The Great Gatsby'
      book.by_statement.should eq             'F. Scott Fitzgerald.'
      book.number_of_pages.should eq          180
      book.contributors[0].name.should eq     'Francis Cugat'
      book.contributors[0].role.should eq     'Cover Art'
      book.copyright_date.should eq           '1925'
      book.isbn_10[0].should eq               '0743273567'
      book.identifiers.goodreads[0].should eq '4671'
      book.identifiers.google[0].should eq    'iXn5U2IzVH0C'
      book.physical_format.should eq          'Trade Paperback'
      book.publishers[0].should eq            'Scribner'
    end
  end

  describe '#author' do
    before do
      key = 'OL1A'
      stub_get("/authors/#{key}", 'author.json')
    end

    it 'returns author details' do
      expect { client.author('OL1A') }.not_to raise_error
      
      author = client.author('OL1A')

      author.should be_a Hashie::Mash
      author.name.should eq                'Sachi Rautroy'
      author.personal_name.should eq       'Sachi Rautroy'
      author.death_date.should eq          '2004'
      author.birth_date.should eq          '1916'
      author.last_modified.type.should eq  '/type/datetime'
      author.last_modified.value.should eq '2008-11-16T07:25:54.131674'
      author.id.should eq                  97
      author.revision.should eq            6
    end
  end
end
