# encoding: utf-8

class AlfredFormatter
    def initialize(format)
        @format = format
        @keepass_items = []
    end

    def add_kp(kp)
        @keepass_items << kp
    end

    def to_string()
        items = []
        @keepass_items.each { |kp| 
            items.push({
                "uid" => kp.title,
                "title" => kp.title,
                "subtitle" => @format % [kp.username, kp.password],
                "autocomplete" => kp.title,
                "arg" => kp.password,
                "text" => {
                    "copy" => kp.password
                },
                "variables" => {
                    "title" => kp.title,
                    "username" => kp.username,
                    "password"=> kp.password
                },
                "mods" => {
                    "cmd" => {
                        "arg" => kp.username
                    }
                }
            })
        }

        return JSON.generate({ "items" => items })
    end
end


class KeepassItem
    def initialize(title, username, password)
        @title = title
        @username = username
        @password = password
    end

    def title
        @title
    end

    def username
        @username
    end

    def password
        @password
    end
end
