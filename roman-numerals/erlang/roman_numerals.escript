#!/usr/bin/env escript
%%! -noshell

main([Filename]) ->
    {ok, Lines} = read_lines(Filename),
    Values = lists:map(fun roman_to_int/1, Lines),
    Total = lists:sum(Values),
    io:format("~p~n", [Total]);
main(_) ->
    io:format("Usage: roman_numerals <filename>~n").

read_lines(File) ->
    case file:open(File, [read]) of
    {ok, Device} ->
        Lines = read_lines(Device, []),
        file:close(Device),
        {ok, Lines};
    {error, Reason} ->
        io:format("Failed to open ~s: ~p~n", [File, Reason]),
        {error, Reason}
    end.

read_lines(Device, Acc) ->
    case io:get_line(Device, "") of
        eof ->
            lists:reverse(Acc);
        {error, Reason} ->
            {error, Reason};
        Line ->
            read_lines(Device, [string:trim(Line) | Acc])
    end.

numeral_map() ->
         #{$I => 1,
            $V => 5,
            $X => 10,
            $L => 50,
            $C => 100,
            $D => 500,
            $M => 1000}.

roman_to_int(Str) ->
    Chars = string:to_graphemes(Str),
    convert(lists:reverse(Chars), 0, 0, {none, 0}).

convert([], _, Total, _) when Total < 4000 ->
    Total;
convert([], _, _, _) ->
    0;
convert([Char | Rest], PrevTotal, Total, {PrevChar, PrevCharCount}) ->
    case maps:find(Char, numeral_map()) of
        error ->
            0;
        {ok, Val} ->
            NewPrevCharCount =
                case PrevChar of
                    none ->
                        1;
                    Char ->
                        PrevCharCount + 1;
                    _ ->
                        0
                end,
            if NewPrevCharCount > 3 ->
                   0;
               true ->
                   NewTotal =
                       if Val < PrevTotal ->
                              Total - Val;
                          true ->
                              Total + Val
                       end,
                   convert(Rest, Val, NewTotal, {Char, NewPrevCharCount})
            end
    end.
