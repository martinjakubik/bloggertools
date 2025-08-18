<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exsl="http://exslt.org/common" xmlns:thr='http://purl.org/syndication/thread/1.0' xmlns:georss='http://www.georss.org/georss' xmlns:gd='http://schemas.google.com/g/2005' extension-element-prefixes="exsl" exclude-result-prefixes="thr georss gd" version="1.0">

    <xsl:output method="html" encoding="UTF-8" />

    <xsl:variable name="siteRootUrl">https://www.supertitle.org/content/books/app</xsl:variable>

    <xsl:key name="postYearKey" match="entry[category/@term='http://schemas.google.com/blogger/2008/kind#post'][id!='uuid']" use="substring(published, 1, 4)"></xsl:key>

    <xsl:template match="/">
        <xsl:apply-templates select="/feed/entry[category/@term='http://schemas.google.com/blogger/2008/kind#post'][id!='uuid']" />
        <xsl:apply-templates select="/feed" mode="index" />
        <exsl:document href="./result.html">
            <html>
                <head>
                    <link rel="stylesheet" href="screen.css"></link>
                </head>
                <body>
                    <ul>
                        <li>
                            <p>entries: <xsl:value-of select="count(/feed/entry[category/@term='http://schemas.google.com/blogger/2008/kind#post'][id!='uuid'])"></xsl:value-of></p>
                        </li>
                    </ul>
                </body>
            </html>
        </exsl:document>
    </xsl:template>

    <xsl:template match="entry[category/@term='http://schemas.google.com/blogger/2008/kind#template']">
    </xsl:template>
    
    <xsl:template match="entry[category/@term='http://schemas.google.com/blogger/2008/kind#settings']">
    </xsl:template>
    
    <xsl:template match="entry[category/@term='http://schemas.google.com/blogger/2008/kind#comment']">
    </xsl:template>
    
    <xsl:template match="entry" mode="linkref">
        <xsl:param name="linkSource" select="post"></xsl:param>
        <xsl:variable name="postId" select="id"></xsl:variable>
        <xsl:variable name="postYear" select="substring(published, 1, 4)"></xsl:variable>
        <xsl:variable name="postMonth" select="substring(published, 6, 2)"></xsl:variable>
        <xsl:variable name="postShortId">   
            <xsl:choose>
                <xsl:when test="starts-with(id, 'tag:blogger.com')">
                    <xsl:value-of select="substring-after(substring-after(id, '-'), '-')" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="substring-before(id, '-')" />
                </xsl:otherwise>
            </xsl:choose>
            </xsl:variable>
        <xsl:variable name="postVeryShortId" select="substring($postShortId, 1, 6)"></xsl:variable>
        <xsl:variable name="postFilenameCandidate" select="concat(substring(translate(translate(title, ' ', '-'), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ;:?!,+#$/', 'abcdefghijklmnopqrstuvwxyz--------'), 1, 16), '-', $postVeryShortId)"></xsl:variable>
        <xsl:variable name="postFilename">
            <xsl:choose>
                <xsl:when test="string-length(title) > 0">
                    <xsl:value-of select="$postFilenameCandidate" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$postShortId" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$linkSource='index'">
                <xsl:value-of select="concat($postYear, '/', $postMonth, '/', $postFilename, '.html')"></xsl:value-of>
            </xsl:when>
            <xsl:when test="$linkSource='post'">
                <xsl:value-of select="concat('../..', '/', $postYear, '/', $postMonth, '/', $postFilename, '.html')"></xsl:value-of>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat($siteRootUrl, '/', $postYear, '/', $postMonth, '/', $postFilename, '.html')"></xsl:value-of>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="/feed" mode="index">
        <exsl:document href="./postIndex.html">
            <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
            <html>
                <head>
                    <link rel="stylesheet" href="../../../screen.css"></link>
                    <link rel="stylesheet" href="screen.css"></link>
                </head>
                <body>
                    <div class="navigation">
                        <a id="navigatehome" href="../../../index.html">Supertitle Home</a>
                    </div>
                    <xsl:apply-templates select="entry[category/@term='http://schemas.google.com/blogger/2008/kind#post'][id!='uuid'][generate-id(.)=generate-id(key('postYearKey', substring(published, 1, 4))[1])]" mode="index"></xsl:apply-templates>
                    <script src="../../../app.js" type="module"></script>
                </body>
            </html>
        </exsl:document>
    </xsl:template>

    <xsl:template match="entry[category/@term='http://schemas.google.com/blogger/2008/kind#post'][id!='uuid']" mode="index">
        <h1 class="postYear"><xsl:value-of select="substring(published, 1, 4)"></xsl:value-of></h1>
        <ul>
            <xsl:for-each select="key('postYearKey', substring(published, 1, 4))">
                <li>
                    <p>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:apply-templates select="." mode="linkref">
                                    <xsl:with-param name="linkSource">index</xsl:with-param>
                                </xsl:apply-templates>
                            </xsl:attribute>
                            <xsl:value-of select="title"></xsl:value-of>
                        </a>
                    </p>
                </li>
            </xsl:for-each>
        </ul>
    </xsl:template>

    <xsl:template match="entry[category/@term='http://schemas.google.com/blogger/2008/kind#post'][id!='uuid']">
        <xsl:variable name="postId" select="id"></xsl:variable>
        <xsl:variable name="postYear" select="substring(published, 1, 4)"></xsl:variable>
        <xsl:variable name="postMonth" select="substring(published, 6, 2)"></xsl:variable>
        <xsl:variable name="postShortId">   
            <xsl:choose>
                <xsl:when test="starts-with(id, 'tag:blogger.com')">
                    <xsl:value-of select="substring-after(substring-after(id, '-'), '-')" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="substring-before(id, '-')" />
                </xsl:otherwise>
            </xsl:choose>
            </xsl:variable>
        <xsl:variable name="postVeryShortId" select="substring($postShortId, 1, 6)"></xsl:variable>
        <xsl:variable name="postFilenameCandidate" select="concat(substring(translate(translate(title, ' ', '-'), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ;:?!,+#$/', 'abcdefghijklmnopqrstuvwxyz--------'), 1, 16), '-', $postVeryShortId)"></xsl:variable>
        <xsl:variable name="postFilename">
            <xsl:choose>
                <xsl:when test="string-length(title) > 0">
                    <xsl:value-of select="$postFilenameCandidate" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$postShortId" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <exsl:document href="./{$postYear}/{$postMonth}/{$postFilename}.html">
            <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
            <html>
                <head>
                    <link rel="stylesheet" title="supertitle:books" type="text/css" media="screen">
                        <xsl:attribute name="href">
                            <xsl:text>../../../../../screen.css</xsl:text>
                        </xsl:attribute>
                    </link>
                    <link rel="stylesheet" title="supertitle:books" type="text/css" media="screen">
                        <xsl:attribute name="href">
                            <xsl:text>../../screen.css</xsl:text>
                        </xsl:attribute>
                    </link>
                </head>
                <body>
                    <div class="navigation">
                        <xsl:if test="./following-sibling::*[category/@term='http://schemas.google.com/blogger/2008/kind#post'][id!='uuid'][1]">
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:apply-templates select="./following-sibling::*[category/@term='http://schemas.google.com/blogger/2008/kind#post'][1]" mode="linkref">
                                        <xsl:with-param name="linkSource">post</xsl:with-param>
                                    </xsl:apply-templates>
                                </xsl:attribute>
                                <xsl:text>previous</xsl:text>
                            </a>
                        </xsl:if>
                        <a href="../../postIndex.html">up</a>
                        <xsl:if test="./preceding-sibling::*[category/@term='http://schemas.google.com/blogger/2008/kind#post'][id!='uuid'][1]">
                            <xsl:if test="./preceding-sibling::*[category/@term='http://schemas.google.com/blogger/2008/kind#post'][1]/id != 'uuid'">
                                <a>
                                    <xsl:attribute name="href">
                                        <xsl:apply-templates select="./preceding-sibling::*[category/@term='http://schemas.google.com/blogger/2008/kind#post'][1]" mode="linkref">
                                            <xsl:with-param name="linkSource">post</xsl:with-param>
                                        </xsl:apply-templates>
                                    </xsl:attribute>
                                    <xsl:text>next</xsl:text>
                                </a>
                            </xsl:if>
                        </xsl:if>
                    </div>
                    <div class="post">
                        <div class="postTitle"><xsl:value-of select="title" /></div>
                        <div class="metadata">
                            <div class="postDatePublished"><xsl:value-of select="published" /></div>
                            <div class="postDateUpdated"><xsl:value-of select="updated" /></div>
                            <div class="postId"><xsl:value-of select="id" /></div>
                        </div>
                        <div class="postContent">
                            <xsl:apply-templates select="content" />
                        </div>
                        <div class="comments">
                            <xsl:for-each select="/feed/entry[thr:in-reply-to/@ref=$postId]">
                                <div class="comment">
                                    <div class="commentTitle"><xsl:value-of select="title" /></div>
                                    <div class="metadata">
                                        <div class="commentDatePublished"><xsl:value-of select="published" /></div>
                                        <div class="commentDateUpdated"><xsl:value-of select="updated" /></div>
                                        <div class="commentId"><xsl:value-of select="id" /></div>
                                    </div>
                                    <div class="commentContent"><xsl:value-of select="content" /></div>
                                </div>
                            </xsl:for-each>
                        </div>
                    </div>
                </body>
            </html>
        </exsl:document>
    </xsl:template>

    <xsl:template match="p">
        <p><xsl:apply-templates></xsl:apply-templates></p>
    </xsl:template>
    
    <xsl:template match="i">
        <i><xsl:apply-templates></xsl:apply-templates></i>
    </xsl:template>
    
    <xsl:template match="b">
        <b><xsl:apply-templates></xsl:apply-templates></b>
    </xsl:template>
    
    <xsl:template match="blockquote">
        <blockquote><xsl:apply-templates></xsl:apply-templates></blockquote>
    </xsl:template>
    
    <xsl:template match="p/link">
        <xsl:variable name="targetId" select="@targetId"></xsl:variable>
        <a>
            <xsl:attribute name="href">
                <xsl:apply-templates select="/feed/entry[id = $targetId]" mode="linkref">
                    <xsl:with-param name="linkSource">post</xsl:with-param>
                </xsl:apply-templates>
            </xsl:attribute>
            <xsl:apply-templates></xsl:apply-templates>
        </a>
    </xsl:template>
    
    <xsl:template match="img">
        <img>
            <xsl:attribute name="class">
                <xsl:value-of select="@class"></xsl:value-of>
            </xsl:attribute>
            <xsl:attribute name="src">
                <xsl:value-of select="@src"></xsl:value-of>
            </xsl:attribute>
            <xsl:apply-templates></xsl:apply-templates></img>
    </xsl:template>
    
  </xsl:stylesheet>