#ifndef SORBET_PARSER_PARSER_H
#define SORBET_PARSER_PARSER_H

#include "Node.h"

namespace sorbet::parser {

class Parser final {
public:
    struct Settings {
        bool traceLexer : 1;
        bool traceParser : 1;

        Settings() : traceLexer(false), traceParser(false) {}
        Settings(bool traceLexer, bool traceParser) : traceLexer(traceLexer), traceParser(traceParser) {}
    };

    static std::unique_ptr<Node> run(core::GlobalState &gs, core::FileRef file, Settings settings,
                                     std::vector<std::string> initialLocals = {});
};

} // namespace sorbet::parser

#endif // SORBET_PARSER_PARSER_H
