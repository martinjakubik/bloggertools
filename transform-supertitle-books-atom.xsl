<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exsl="http://exslt.org/common" xmlns:thr='http://purl.org/syndication/thread/1.0' xmlns:georss='http://www.georss.org/georss' xmlns:gd='http://schemas.google.com/g/2005' extension-element-prefixes="exsl" exclude-result-prefixes="thr georss gd" version="1.0">

    <xsl:output method="html"/>

    <xsl:variable name="siteRootUrl">https://www.supertitle.org/content/books</xsl:variable>

    <xsl:template match="/">
        <xsl:apply-templates select="/feed/entry[category/@term='http://schemas.google.com/blogger/2008/kind#post']" />
        <xsl:apply-templates select="/feed" mode="index" />
        <exsl:document href="./result.html">
            <html>
                <body>
                    <ul>
                        <li>
                            <p>entries: <xsl:value-of select="count(/feed/entry[category/@term='http://schemas.google.com/blogger/2008/kind#post'])"></xsl:value-of></p>
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
        <xsl:variable name="postFilenameCandidate" select="concat(substring(translate(translate(title, ' ', '-'), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ;:?!,+#$', 'abcdefghijklmnopqrstuvwxyz-------'), 1, 16), '-', $postVeryShortId)"></xsl:variable>
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
        <xsl:value-of select="concat($siteRootUrl, '/', $postYear, '/', $postMonth, '/', $postFilename, '.html')"></xsl:value-of>
    </xsl:template>

    <xsl:template match="/feed" mode="index">
        <exsl:document href="./postIndex.html">
            <html>
                <body>
                    <ul>
                        <xsl:for-each select="entry[category/@term='http://schemas.google.com/blogger/2008/kind#post']">
                            <li>
                                <p>
                                    <a>
                                        <xsl:attribute name="href">
                                            <xsl:apply-templates select="." mode="linkref"></xsl:apply-templates>
                                        </xsl:attribute>
                                        <xsl:value-of select="title"></xsl:value-of>
                                    </a>
                                </p>
                            </li>
                        </xsl:for-each>
                    </ul>
                </body>
            </html>
        </exsl:document>
    </xsl:template>

    <xsl:template match="entry[category/@term='http://schemas.google.com/blogger/2008/kind#post']">
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
        <xsl:variable name="postFilenameCandidate" select="concat(substring(translate(translate(title, ' ', '-'), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ;:?!,+#$', 'abcdefghijklmnopqrstuvwxyz-------'), 1, 16), '-', $postVeryShortId)"></xsl:variable>
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
            <html>
                <link rel="stylesheet" title="supertitle:books" type="text/css" media="screen">
                    <xsl:attribute name="href">
                        <xsl:value-of select="concat($siteRootUrl, '/screen.css')" />
                    </xsl:attribute>
                </link>
                <body>
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
                    <div class="navigation">
                        <xsl:if test="./following-sibling::*[category/@term='http://schemas.google.com/blogger/2008/kind#post'][1]">
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:apply-templates select="./following-sibling::*[category/@term='http://schemas.google.com/blogger/2008/kind#post'][1]" mode="linkref"></xsl:apply-templates>
                                </xsl:attribute>
                                <xsl:text>previous</xsl:text>
                            </a>
                        </xsl:if>
                        <xsl:if test="./preceding-sibling::*[category/@term='http://schemas.google.com/blogger/2008/kind#post'][1]">
                            <xsl:if test="./preceding-sibling::*[category/@term='http://schemas.google.com/blogger/2008/kind#post'][1]/id != 'uuid'">
                                <a>
                                    <xsl:attribute name="href">
                                        <xsl:apply-templates select="./preceding-sibling::*[category/@term='http://schemas.google.com/blogger/2008/kind#post'][1]" mode="linkref"></xsl:apply-templates>
                                    </xsl:attribute>
                                    <xsl:text>next</xsl:text>
                                </a>
                            </xsl:if>
                        </xsl:if>
                    </div>
                </body>
            </html>
        </exsl:document>
    </xsl:template>

    <xsl:template match="p">
        <p><xsl:apply-templates></xsl:apply-templates></p>
    </xsl:template>
    
    <xsl:template match="p/link">
        <xsl:variable name="targetId" select="@targetId"></xsl:variable>
        <a>
            <xsl:attribute name="href">
                <xsl:apply-templates select="/feed/entry[id = $targetId]" mode="linkref"></xsl:apply-templates>
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